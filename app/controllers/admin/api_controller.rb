module Admin
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate

    def update_location
      render json: params
    end

    private

    def authenticate
      head :unauthorized unless auth_token && auth_token == Rails.application.secrets.admin_api_token
    end

    def auth_token
      params[:token] || (request.headers['Authorization']&.scan(/Bearer (.+)\s*$/)&.first&.first)
    end
  end
end
