# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_context
  before_action :set_current_user
  before_action :block_unconfirmed
  before_action :set_raven_context

  protected

  def set_context
    @app = App.first_with_cache
  end

  def set_current_user
    @user = load_current_user
    RedisWrapper.set("session-#{@user.id}", @user.to_json)
    RedisWrapper.expire("session-#{@user.id}", 86_400)
    cookies[:user_name] = @user.name
    cookies[:user_id] = @user.id
  end

  def load_current_user
    cached = RedisWrapper.get("session-#{current_user.id}")
    cached ? User.new(JSON.parse(cached)) : User.find(current_user.id)
  end

  def block_unconfirmed
    return unless @user.unconfirmed?
    redirect_to \
      wait_path,
      notice: "가입 대기 상태입니다. 관리자에게 문의해주세요."
  end

  def set_raven_context
    Raven.user_context(id: current_user&.id) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
