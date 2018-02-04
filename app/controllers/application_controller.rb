class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :add_webmention_endpoint

  before_action :set_locale

  private

  def add_webmention_endpoint
    response.headers['Link'] = "<#{webmentions_url}>; rel=\"webmention\"" if response.status == 200
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
