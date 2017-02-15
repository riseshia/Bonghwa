# frozen_string_literal: true
source "https://rubygems.org"

gem "rails", "5.0.1"
gem "puma"
gem "sqlite3"
gem "mysql2", "~> 0.4"

gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"
gem "react-rails"

gem "jb"

gem "sass-rails"
gem "uglifier"
gem "jquery-rails"
gem "bcrypt"
gem "redis", "3.3.1"
gem "redis-rails"
gem "will_paginate"
gem "figaro"
gem "devise"
gem "paperclip", "~> 4.0"

group :development do
  gem "web-console", "~> 2.0"
  gem "byebug"

  gem "rubocop",                require: false
  gem "rails_best_practices",   require: false
  gem "foreman"
  gem "guard"
  gem "guard-minitest"

  # Deployment
  gem "capistrano",             require: false
  gem "capistrano-rbenv",       require: false
  gem "capistrano-rails",       require: false
  gem "capistrano-bundler",     require: false
  gem "capistrano-secrets-yml", "~> 1.0.0", require: false
  gem "capistrano3-puma",       require: false
end

group :test do
  gem "capybara"
  gem "codeclimate-test-reporter", "~> 1.0.0"
  gem "coveralls", require: false
  gem "database_rewinder"
  gem "minitest-rails"
  gem "poltergeist"
  gem "simplecov"
  gem "mock_redis"
end
