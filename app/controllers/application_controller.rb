class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :add_link_headers

  private

  def add_link_headers
    if response.status == 200
      link_headers = [
        "<#{webmentions_url}>; rel=\"webmention\"",
        "<#{micropub_url}>; rel=\"micropub\""
      ]

      response.headers['Link'] = link_headers.join(', ')
    end
  end
end
