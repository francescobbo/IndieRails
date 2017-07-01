class UpdateWeatherJob < ApplicationJob
  queue_as :default

  def perform
    location = LocationUpdate.order(created_at: :desc).first
    return unless location

    weather = WeatherUpdate.first || WeatherUpdate.new
    raw = Weather.for_coords(location.latitude, location.longitude)

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
