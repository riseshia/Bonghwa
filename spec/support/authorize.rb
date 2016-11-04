# frozen_string_literal: true
# Authorize mode
# This provice simple sign_in method for test
module Authorize
  def sign_in_via_browser(user)
    setup
    user_obj = create(user)
    user_attr = attributes_for(user)
    visit "/"
    within("#new_user") do
      fill_in "user_login_id", with: user_attr[:login_id]
      fill_in "user_password", with: user_attr[:password]
    end
    click_button "Log in"
    user_obj
  end

  def no_sign_in_via_browser
    setup
  end

  def setup
    RedisWrapper.del("app-data")
    create(:app)
  end
end

# Register this module
RSpec.configure { |c| c.include Authorize }
