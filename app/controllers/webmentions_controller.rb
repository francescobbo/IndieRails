class WebmentionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    webmention = Webmention.find_or_initialize_by(source: params[:source],
                                                  target: params[:target],
                                                  outbound: false)

    if webmention.new_record?
      webmention.status = :created
      webmention.outbound = false

      if webmention.save
        response['Location'] = webmention_url(webmention)
        head :created
      else
        byebug
        render plain: 'Unacceptable webmention source or target', status: :bad_request
      end
    else
      response['Location'] = webmention_url(webmention)
      head :created
    end
  end

  def show
    webmention = Webmention.inbound.find(params[:id])

    case webmention.status.to_sym
      when :created
        render plain: 'The webmention is pending verification', status: :created
      when :accepted
        render plain: 'The webmention has been verified and is pending manual approval', status: :created
      when :published
        render plain: 'The webmention has been approved and may be visible on the mentioned page'
      when :rejected
        render plain: 'The webmention has been rejected', status: :unprocessable_entity
      when :removed
        render plain: 'The webmention has been removed due to source content expiration', status: :gone
      else
        render plain: 'Internal Server Error', status: :internal_server_error
    end
  end
end
