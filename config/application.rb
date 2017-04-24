# frozen_string_literal: true
require_relative "ignore_warning"
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bonghwa
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.cache_store = \
      :redis_store,
      "redis://#{Rails.application.secrets.redis_host}:" \
      "#{Rails.application.secrets.redis_port}/0/cache",
      { expires_in: 90.minutes }

    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("app/uploaders")

    # add '/lib' to Eager Load path
    config.eager_load_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("app/uploaders")

    config.time_zone = "Seoul"

    config.generators do |g|
      g.test_framework :minitest, spec: false, fixture: false
    end
  end
end
