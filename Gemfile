# frozen_string_literal: true
source "https://rubygems.org"

gem "rails", "5.0.2"
gem "puma"

gem "therubyracer"
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"
gem "react-rails"
gem "jquery-rails"

gem "sass-rails"
gem "uglifier"

gem "jb"

gem "kaminari"

# Environment Variable
gem "figaro"

# Auth
gem "devise"
gem "bcrypt"

# Fileupload
gem "carrierwave", "~> 1.0"
gem "carrierwave-bombshelter"
gem "file_validators"

# Redis
gem "redis", "3.3.1"
gem "redis-rails"

# DB
gem "sqlite3"
gem "mysql2", "~> 0.4"

gem "newrelic_rpm"

group :development, :test do
  gem "byebug"
end

group :development do
  gem "web-console", "~> 2.0"

  gem "rubocop",                require: false
  gem "rails_best_practices",   require: false
  gem "foreman"
  gem "guard"
  gem "guard-minitest"

  # Deployment
  gem "capistrano",             require: false
  gem "capistrano-rbenv",       require: false
  gem "capistrano-rails",       require: false
  gem "capistrano-nvm",         require: false
  gem "capistrano-bundler",     require: false
  gem "capistrano-secrets-yml", "~> 1.0.0", require: false
  gem "capistrano3-puma",       require: false
end

group :test do
  gem "capybara"
  gem "coveralls", require: false
  gem "database_rewinder"
  gem "minitest-rails"
  gem "poltergeist"
  gem "simplecov"
  gem "mock_redis"
end
