# Authorize mode
# This provice simple sign_in method for test
module Authorize
  def sign_in(user)
    user_obj = create(user)
    session[:user_id] = user_obj.id
    session[:user_name] = user_obj.name
    session[:user_level] = user_obj.level
    # cookies[:user_name] = { value: user_obj.name, expires: realTime + 7.days } unless user_obj.name == cookies[:user_name]
  end

  def sign_out
    $redis.del("#{$servername}:session-#{session[:user_id]}")
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_level] = nil
  end
end

# Register this module
RSpec.configure {|c| c.include Authorize }
