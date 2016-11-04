# frozen_string_literal: true

module Actions
  def type(message)
    find("#contents").set(message)
  end

  def submit
    click_on "Submit"
  end
end

RSpec.configure do |config|
  config.include Actions, type: :feature
end
