source 'https://rubygems.org'

gem 'rails', '4.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier'
end

# To test Project
group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails', "~> 4.0"
  gem 'capybara', '~> 2.4.0'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'protected_attributes'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'rvm-capistrano'

gem 'redis-rails'

group :deployment do
  gem 'capistrano', '2.15.5'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'capistrano_rsync_with_remote_cache'
end

# paging
gem 'will_paginate', '3.0.3'

# Caching
gem 'dalli'

# json
gem 'oj'

# To use debugger
# gem 'debugger'

# To provide file Upload
gem "paperclip", "~> 3.0"