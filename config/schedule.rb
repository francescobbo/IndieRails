every 10.minutes do
  runner "UpdateWeatherJob.perform_now"
end
