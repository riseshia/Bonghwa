# frozen_string_literal: true
# ApplicationController
class ApplicationController < ActionController::Base
  before_action :app_setting
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :block_unconfirmed
  protect_from_forgery with: :exception

  protected

  def app_setting
    @app = App.first_with_cache
    @links = Link.all_with_cache
  end

  def set_current_user
    cached = RedisWrapper.get("session-#{current_user.id}")

    if cached
      @user = User.new(JSON.parse(cached))
    else
      @user = User.find(current_user.id)
      RedisWrapper.set("session-#{@user.id}", @user.to_json)
    end
    RedisWrapper.expire("session-#{@user.id}", 86_400)
    cookies[:user_name] = @user.name
    cookies[:user_id] = @user.id
  end

  def block_unconfirmed
    if @user.level < 1
      redirect_to wait_path, notice: "가입 대기 상태입니다. 관리자에게 문의해주세요."
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

  def admin_check
    if @user.level != 999
      redirect_to index_path, notice: "접근 권한이 없습니다. 관리자에게 문의해주세요."
    end
  end
end
