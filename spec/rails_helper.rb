# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "factory_girl_rails"

require "simplecov"
require "codeclimate-test-reporter"
if ENV["CODECLIMATE_REPO_TOKEN"]
  SimpleCov.start "rails" do
    add_filter "vendor"
    add_filter "spec"
  end
  CodeClimate::TestReporter.start
end

require "capybara/rspec"
require "capybara/rails"
require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  # JS Error disable.
  Capybara::Poltergeist::Driver.new(app,
                                    js_errors: false,
                                    phantomjs_options: %w(--load-images=no),
                                    timeout: 240)
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.default_driver = :rack_test
Capybara.default_selector = :css
Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.order = "random"

  # config.include WaitForAjax, type: :feature

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
