Airbrake.configure do |config|
  config.host                = 'https://errors.blueberry.cz'
  config.project_id          = 1
  config.project_key         = 'API_KEY'

  config.environment         = Rails.env
  config.ignore_environments = %w(development test)
  config.blacklist_keys      = [/password/i]
end

Airbrake.add_filter do |notice|
  if notice[:errors].any? { |error| error[:type] == 'ActiveRecord::RecordNotFound' }
    notice.ignore!
  end
end
