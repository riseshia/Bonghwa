#encoding: utf-8

class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
    user = User.find_by_id(cookies[:user_id])
    if user.nil?
      render 'new', layout: 'signin'
    elsif user.password_digest[0..9] == cookies[:auth_key]
      session[:user_id]  = user.id
      session[:user_name] = user.name
      session[:user_level] = user.level
      
      # cookie update for auto login user
      cookies[:user_id] = { value: user.id, expires: realTime() + 7.days}
      cookies[:user_name] = { value: user.name, expires: realTime() + 7.days}
      cookies[:auth_key] = { value: user.password_digest[0..9], expires: realTime() + 7.days}

      user.recent_login = realTime
      user.save!
      
      redirect_to index_path
    else
      redirect_to index_path if session[:user_id]
    end
  end

  def create
    user = User.find_by_login_id(params[:login_id])
    
    # verify user
    if user and user.authenticate(params[:password])
      session[:user_id]  = user.id
      session[:user_name] = user.name
      session[:user_level] = user.level
      
      # 두개는 js에서도 사용하기때문에 언제나 생성.
      cookies[:user_id] = { value: user.id, expires: realTime() + 7.days}
      cookies[:user_name] = { value: user.name, expires: realTime() + 7.days}

      # auto login
      if params[:auto_login_option]
        cookies[:auth_key] = { value: user.password_digest[0..9], expires: realTime() + 7.days}
      end

      redirect_to index_path
    else
      redirect_to login_path, notice: "아이디/비밀번호가 올바르지 않습니다."
    end
  end

  def destroy
    session[:user_id]  = nil
    session[:user_name] = nil
    session[:user_level] = nil
    
    cookies.delete :user_id
    expires_now
    
    redirect_to login_path, notice: "로그아웃 되었습니다."
  end
end