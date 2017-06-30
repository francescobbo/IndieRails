require 'open-uri'

class Weather
  class << self
    def for_coords(latitude, longitude)
      url = "http://api.openweathermap.org/data/2.5/weather?lat=#{latitude}&lon=#{longitude}&APPID=#{Rails.application.secrets.openweather_key}"
      JSON.parse(open(url).read).deep_symbolize_keys
    end
  end
end
