module Admin
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate

    def update_location
      head :accepted

      raw = Weather.for_coords(params[:latitude], params[:longitude]) rescue nil
      if raw
        LocationUpdate.create({
          latitude: params[:latitude],
          longitude: params[:longitude],
          weather: raw[:weather],
          wind: raw[:wind],
          temperature: raw[:main][:temp] - 273.15,
          humidity: raw[:main][:humidity],
          sunrise: Time.at(raw[:sys][:sunrise]),
          sunset: Time.at(raw[:sys][:sunset])
        })
      else
        LocationUpdate.create(latitude: params[:latitude], longitude: params[:longitude])
      end
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
