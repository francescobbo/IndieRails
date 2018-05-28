require 'net/http'
require 'active_support'
require 'active_support/core_ext'
require 'nokogiri'

class WebmentionClient
  ACCEPTABLE_RESPONSES = 200..202.freeze

  class UnexpectedResponse < StandardError; end

  def deliver(source, target)
    webmention_uri = discover(target)
    return unless webmention_uri

    response = perform(webmention_uri, source, target)
    return unless response

    response_code = response.code.to_i
    return unless response_code.in?(ACCEPTABLE_RESPONSES)

    {
      status: response.code.to_i == 200 ? :created : :accepted,
      status_endpoint: response.code.to_i == 201 ? response['location'] : nil
    }
  end

  def perform(webmention_uri, source, target)
    request = Net::HTTP::Post.new(webmention_uri.request_uri, 'User-Agent' => user_agent)
    request.set_form_data(source: source, target: target)
    client(uri).request(request)

  rescue StandardError
    # Network error?
    nil
  end

  def discover(url)
    head, final_url = fetch(url, :head)
    endpoint = discover_from_page(head)

    unless endpoint
      page, final_url = fetch(url, :get)
      endpoint = discover_from_page(page)
    end

    return URI.join(final_url, endpoint) if endpoint
  end

  def discover_from_page(page)
    endpoint = endpoint_from_headers(page)

    return endpoint if endpoint
    return unless page.body

    document = Nokogiri::HTML(page.body)
    attribute_selector = '[rel~="webmention"][href]'
    document.css("link#{attribute_selector}, a#{attribute_selector}").first.try(:[], :href)
  end

  def fetch(url, method = :get, redirect_limit: 10)
    uri = URI.parse(url)
    (1 + redirect_limit).times do
      response = simple_request(uri, method)

      return [response, uri.to_s] if response.code.to_i.in?(200..299)
      uri = URI.join(uri.to_s, response['location'])
    end
  end

  def simple_request(uri, method)
    request = Net::HTTP.const_get(method.capitalize).new(uri.request_uri, 'User-Agent' => user_agent)

    response = client(uri).request(request)

    raise UnexpectedResponse, "Fetch failed with status #{response.code}." unless response.code.to_i.in?(200..399)
    response
  end

  def client(uri)
    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = uri.scheme == 'https'
    client
  end

  def user_agent
    "Webmention - #{Settings.host}"
  end

  def endpoint_from_headers(response)
    response.get_fields('Link')&.each do |header|
      match = header.match(/\A.*<(.+)>\s*;\s*(?:rel=webmention|rel=".*\bwebmention\b.*")\s*\z/)
      return match[1] if match
    end

    nil
  end
end
