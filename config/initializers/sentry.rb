if Rails.env.production?
  Raven.configure do |config|
    config.dsn = ENV["SENTRY_ID"]
  end
end
