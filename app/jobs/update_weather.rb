class PingCrawlersJob < ApplicationJob
  queue_as :default

  def perform
    weather = WeatherUpdate.first || WeatherUpdate.new

    weather.update_attributes({
      weather: raw[:weather],
      wind: raw[:wind],
      temperature: raw[:main][:temp] - 273.15,
      humidity: raw[:main][:humidity],
      sunrise: Time.at(raw[:sys][:sunrise]),
      sunset: Time.at(raw[:sys][:sunset])
    })

    weather.save
  end
end
