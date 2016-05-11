# frozen_string_literal: true
# Authorize mode
# This provice simple sign_in method for test
module Authorize
  def sign_in_via_browser(user)
    RedisWrapper.del("app-data")
    create(:app)
    create(user)
    user_obj = attributes_for(user)
    visit "/"
    within("#new_user") do
      fill_in "user_login_id", with: user_obj[:login_id]
      fill_in "user_password", with: user_obj[:password]
    end
    click_button "Log in"
  end
end

# Register this module
RSpec.configure { |c| c.include Authorize }
