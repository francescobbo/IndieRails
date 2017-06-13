class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :add_webmention_endpoint

  private

  def add_webmention_endpoint
    response.headers['Link'] = "<#{webmentions_url}>; rel=\"webmention\"" if response.status == 200
  end
end
