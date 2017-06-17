class PingCrawlersJob < ApplicationJob
  queue_as :default

  def perform
    urls = [
      "https://www.google.com/webmasters/sitemaps/ping?sitemap=#{sitemap_url}",
      "https://www.bing.com/webmaster/ping.aspx?siteMap=#{sitemap_url}",
      "https://feedburner.google.com/fb/a/pingSubmit?bloglink=#{root_url}"
    ]

    urls.each do |url|
      uri = URI.parse(url)
      client = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl = uri.scheme == 'https'

      request = Net::HTTP::Get.new(uri.request_uri)

      client.request(request)
    end
  end
end
