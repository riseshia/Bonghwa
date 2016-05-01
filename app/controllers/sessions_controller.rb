# frozen_string_literal: true
# SessionsController
class SessionsController < ApplicationController
  skip_before_action :authorize
  skip_before_action :block_unconfirmed

  def new
    user = User.find_by_id(cookies[:user_id])
    if user.nil?
      render "new", layout: "signin"
    elsif user.password_digest[0..9] == cookies[:auth_key]
      setup_session user

      # cookie update for auto login user
      cookies[:user_id] = { value: user.id, expires: Time.zone.now + 7.days }
      cookies[:user_name] = {
        value: user.name, expires: Time.zone.now + 7.days }
      cookies[:auth_key] = {
        value: user.password_digest[0..9], expires: Time.zone.now + 7.days }

      user.recent_login = Time.zone.now
      user.save!

      redirect_to index_path
    elsif session[:user_id]
      redirect_to index_path 
    end
  end

  def create
    user = User.find_by_login_id(params[:login_id])

    # verify user
    if user && user.authenticate(params[:password])
      setup_session user

      # 두개는 js에서도 사용하기때문에 언제나 생성.
      cookies[:user_id] = { value: user.id, expires: Time.zone.now + 7.days }
      cookies[:user_name] = {
        value: user.name, expires: Time.zone.now + 7.days }

      # auto login
      if params[:auto_login_option]
        cookies[:auth_key] = {
          value: user.password_digest[0..9], expires: Time.zone.now + 7.days }
      end

      redirect_to index_path
    else
      redirect_to login_path, notice: "아이디/비밀번호가 올바르지 않습니다."
    end
  end

  def destroy
    remove_session

    cookies.delete :user_id
    expires_now

    redirect_to login_path, notice: "로그아웃 되었습니다."
  end
end
