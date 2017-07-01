require 'open-uri'

class PagesController < ApplicationController
  def now
    set_meta_tags(title: 'Live Status Update')

    location = LocationUpdate.order(created_at: :desc).first
    address = reverse_geocode(location)[:address_components]

    city = address.find { |component| (component[:types] & ['locality', 'administrative_area_level_2']).any? }[:long_name]
    region = address.find { |component| component[:types].include?('administrative_area_level_1') }[:long_name]
    country = address.find { |component| component[:types].include?('country') }[:long_name]

    render locals: {
      location: location,
      address: {
        city: city,
        region: region,
        country: country
      },
      weather: WeatherUpdate.first
    }
  end

  def reverse_geocode(location)
    url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{location.latitude},#{location.longitude}&key=#{Rails.application.secrets.google_api_key}"
    JSON.parse(open(url).read).deep_symbolize_keys[:results][0]
  end
end
