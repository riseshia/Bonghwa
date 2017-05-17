source "https://rubygems.org"

gem "puma"
gem "rails", "5.1.0"

gem "jquery-rails"
gem "sprockets", ">= 3.0.0"
gem "therubyracer"

gem "sass-rails"
gem "uglifier"

gem "jb"

gem "kaminari"

# Environment Variable
gem "figaro"

# Auth
gem "bcrypt"
gem "devise"
gem "rack-cors", require: "rack/cors"
gem "simple_token_authentication"

# Fileupload
gem "carrierwave", "~> 1.0"
gem "carrierwave-bombshelter"
gem "file_validators"

# Redis
gem "redis"
gem "redis-rails"

# DB
gem "mysql2", "~> 0.4"
gem "sqlite3"

gem "newrelic_rpm"
gem "sentry-raven"

group :development, :test do
  gem "byebug"
end

group :development do
  gem "web-console"

  gem "foreman"
  gem "guard"
  gem "guard-minitest"
  gem "rails_best_practices",   require: false
  gem "rubocop",                require: false

  # Deployment
  gem "capistrano",             require: false
  gem "capistrano-bundler",     require: false
  gem "capistrano-nvm",         require: false
  gem "capistrano-rails",       require: false
  gem "capistrano-rbenv",       require: false
  gem "capistrano-secrets-yml", "~> 1.0.0", require: false
  gem "capistrano3-puma",       require: false
end

group :test do
  gem "capybara"
  gem "coveralls", require: false
  gem "database_rewinder"
  gem "minitest-rails"
  gem "mock_redis"
  gem "poltergeist"
  gem "simplecov"
end
