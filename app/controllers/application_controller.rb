# frozen_string_literal: true
# ApplicationController
class ApplicationController < ActionController::Base
  before_action :app_setting
  before_action :authorize
  before_action :block_unconfirmed
  protect_from_forgery with: :exception

  protected

  def app_setting
    @app = App.first_with_cache
    @links = Link.all_with_cache
  end

  def authorize
    if session[:user_id]
      cached = RedisWrapper.get("session-#{session[:user_id]}")

      if cached
        @user = User.new(JSON.parse(cached))
      else
        @user = User.find(session[:user_id])
        RedisWrapper.set("session-#{@user.id}", @user.to_json)
      end
      RedisWrapper.expire("session-#{session[:user_id]}", 86_400)
    else
      redirect_to login_path, notice: "로그인해주세요."
    end
  end

  def block_unconfirmed
    if @user.level < 1
      remove_session
      redirect_to login_path, notice: "가입 대기 상태입니다. 관리자에게 문의해주세요."
    else
      setup_session @user
      cookies[:user_name] = {
        value: @user.name, expires: Time.zone.now + 7.days }
    end
  end

  def update_login_info(user)
    RedisWrapper.zadd("active-users", Time.zone.now.to_i, user.name) \
      unless user.id == 1
  end

  def get_recent_users
    now_timestamp = Time.zone.now.to_i
    before_timestamp = now_timestamp - 40
    RedisWrapper.zrangebyscore("active-users", before_timestamp, now_timestamp)
      .sort.map { |user| { "name" => user } }
  end

  def remove_session
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_level] = nil
  end

  def setup_session(user)
    session[:user_id] = user.id
    session[:user_name] = user.name
    session[:user_level] = user.level
  end

  def admin_check
    if @user.nil?
      redirect_to login_path, notice: "로그인해주세요."
    elsif @user.level != 999
      redirect_to index_path, notice: "접근 권한이 없습니다. 관리자에게 문의해주세요."
    end
  end
end
