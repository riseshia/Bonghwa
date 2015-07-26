source 'https://rubygems.org'

gem 'rails', '4.1.7'
gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt'
gem 'protected_attributes'
gem 'redis-rails'
gem 'will_paginate', '3.0.7'
gem 'oj'
gem 'figaro'
gem "paperclip", "~> 3.0"

# To test Project
group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails', "~> 4.0"
  gem 'capybara', '~> 2.4.0'
end

group :deployment do
  gem 'highline'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'unicorn'
  gem 'capistrano-bundler'
  gem 'capistrano-secrets-yml', '~> 1.0.0'
  gem 'capistrano-unicorn-nginx', :git => 'https://github.com/riseshia/capistrano-unicorn-nginx.git'
end
