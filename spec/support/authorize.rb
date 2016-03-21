# frozen_string_literal: true
# Authorize mode
# This provice simple sign_in method for test
module Authorize
  def sign_in(user)
    $redis.del("#{$servername}:app-data")
    create(:app)
    user_obj = create(user)
    session[:user_id] = user_obj.id
    session[:user_name] = user_obj.name
    session[:user_level] = user_obj.level
  end

  def sign_in_via_browser(user)
    $redis.del("#{$servername}:app-data")
    create(:app)

    create(user)
    user_obj = attributes_for(user)
    visit "/"
    within("#login_form") do
      fill_in "login_id", with: user_obj[:login_id]
      fill_in "password", with: user_obj[:password]
    end
    click_button "Sign in"
  end

  def sign_out
    $redis.del("#{$servername}:session-#{session[:user_id]}")
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_level] = nil
  end
end

# Register this module
RSpec.configure { |c| c.include Authorize }
