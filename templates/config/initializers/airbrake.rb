Airbrake.configure do |config|
  config.host = 'http://errors.blueberry.cz'
  config.project_id = true
  config.project_key = 'APIKEY'
  config.ignore_environments = %w(development test)
end
