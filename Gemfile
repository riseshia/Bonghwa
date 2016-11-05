source "https://rubygems.org"

gem "rails", "5.0.0.1"
gem "puma"
gem "sqlite3"
gem "mysql2", "~> 0.4"

# Gems used only for assets and not required
# in production environments by default.
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"
gem "react-rails"

gem "sass-rails"
gem "uglifier"
gem "jquery-rails"
gem "bcrypt"
gem "redis-rails"
gem "will_paginate"
gem "figaro"
gem "devise"
gem "paperclip", "~> 4.0"

group :development do
  gem "capistrano",             require: false
  gem "capistrano-rbenv",       require: false
  gem "capistrano-rails",       require: false
  gem "capistrano-bundler",     require: false
  gem "capistrano-secrets-yml", "~> 1.0.0"
  gem "capistrano3-puma",       require: false
  
  gem "web-console", "~> 2.0"
  gem "byebug"

  gem "rubocop",                require: false
  gem "rails_best_practices",   require: false
  gem "foreman"
end

group :test do
  gem "rspec-rails"
  gem "rspec-collection_matchers"
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "poltergeist"
  gem "shoulda-matchers", "~> 3.0"
  gem "simplecov", require: false
  gem "codeclimate-test-reporter", require: false
  gem "database_rewinder"
end
