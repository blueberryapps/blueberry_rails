if %w(production staging).include? Rails.env
  TranslationEngine.config do |config|
    # key for user
    config.api_key  = 'API_KEY'

    # url to Translation Server
    config.api_host = 'http://127.0.0.1:3000'

    # enable screenshot functionality (default is false)
    config.use_screenshots  = true

    # enable to send translation after every request and receive translations
    # when something changed (default is false)
    config.use_catcher      = true

    # Timeout for connecting to translation server
    # config.timeout = 5

    # If true TranslationEngine will throw exceptions on connection problems
    # If false TranslationEngine will just log exception to Rails.logger
    config.raise_exceptions = Rails.env.development?
  end
end
