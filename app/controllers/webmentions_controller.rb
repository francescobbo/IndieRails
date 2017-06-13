class WebmentionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    webmention = Webmention.find_or_initialize_by(source: params[:source],
                                                  target: params[:target],
                                                  outbound: false)

    byebug

    webmention.status = :created if webmention.new_record?

    if !webmention.new_record? || webmention.save
      response['Location'] = webmention_url(webmention)
      head :created
    else
      render plain: 'Unacceptable webmention source or target', status: :bad_request
    end
  end

  def show
    webmention = Webmention.inbound.find(params[:id])

    if webmention.status_response
      render webmention.status_response
    else
      render plain: 'Internal Server Error', status: :internal_server_error
    end
  end
end
