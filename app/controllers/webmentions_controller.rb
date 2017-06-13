class WebmentionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    webmention = Webmention.create(source: params[:source],
                                   target: params[:target],
                                   outbound: false,
                                   status: :created)

    if webmention.save
      response['Location'] = webmention_url(webmention)
      render status: :created
    else
      render text: 'Unacceptable webmention source or target', status: :bad_request
    end
  end

  def show
    webmention = Webmention.inbound.find(params[:id])

    case webmention.status
      when :created
        render text: 'The webmention is pending verification', status: :created
      when :accepted
        render text: 'The webmention has been verified and is pending manual approval', status: :created
      when :published
        render text: 'The webmention has been approved and may be visible on the mentioned page'
      when :rejected
        render text: 'The webmention has been rejected', status: :unprocessable_entity
      when :removed
        render text: 'The webmention has been removed due to source content expiration', status: :gone
      else
        render text: 'Internal Server Error', status: :internal_server_error
    end
  end
end
