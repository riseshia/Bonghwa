# frozen_string_literal: true
# ApiController
class ApiController < ApplicationController
  def create
    Firewood.create(
      user_id: @user.id,
      user_name: @user.name,
      prev_mt: params[:firewood][:prev_mt],
      contents: params[:firewood][:contents],
      attached_file: params[:attach],
      adult_check: params[:adult_check],
      app: @app,
      user: @user
    )

    render_empty_json
  end

  def destroy
    fw = Firewood.find(params[:id])
    fw.destroy if fw.editable? @user

    render_empty_json
  end

  # Get recent 50 firewood from now
  def now
    type = params[:type]
    firewoods = case type
                when "1" # Now
                  Firewood.trace(@user.id, 50)
                when "2" # Mt
                  Firewood.mention(@user.id, @user.name, 50)
                when "3" # Me
                  Firewood.me(@user.id, 50)
                 end.map(&:to_hash_for_api)

    update_login_info
    users = recent_users

    render_fws_and_users(firewoods, users)
  end

  # 지정한 멘션의 루트를 가지는 것을 최근 것부터 1개 긁어서 json으로 돌려준다.
  def get_mt
    mts = Firewood.find_mt(params[:prev_mt], @user.id)
                  .map(&:to_hash_for_api)
    render_fws(mts)
  end

  # after 이후의 장작을 최대 1000개까지 내림차순으로 받아온다.
  def pulling
    type = params[:type]
    limit = 1000

    firewoods = case type
                when "1" # Now
                  Firewood.after(params[:after])
                          .trace(@user.id, limit)
                when "2" # Mt
                  Firewood.after(params[:after])
                          .mention(@user.id, @user.name, limit)
                when "3" # Me
                  Firewood.after(params[:after]).me(@user.id, limit)
                end.map(&:to_hash_for_api)
    update_login_info
    users = recent_users

    render_fws_and_users(firewoods, users)
  end

  def trace
    limit = limit_count_to_50 params[:count].to_i # Limit maximum size
    type = params[:type]

    firewoods = case type
                when "1" # Now
                  Firewood.before(params[:before]).trace(@user.id, limit)
                when "2" # Mt
                  Firewood.before(params[:before])
                          .mention(@user.id, @user.name, limit)
                when "3" # Me
                  Firewood.before(params[:before])
                          .me(@user.id, limit)
                end.map(&:to_hash_for_api)
    update_login_info

    render_fws_and_users(firewoods, users)
  end

  private

  def limit_count_to_50(number)
    number > 50 ? 50 : number
  end

  def recent_users
    now_timestamp = Time.zone.now.to_i
    before_timestamp = now_timestamp - 40
    RedisWrapper.zrangebyscore("active-users", before_timestamp, now_timestamp)
                .sort.map { |user| { "name" => user } }
  end

  def update_login_info
    RedisWrapper.zadd("active-users", Time.zone.now.to_i, @user.name) \
      unless @user.id == 1
  end

  def render_empty_json
    render json: JSON.dump("")
  end

  def render_fws(firewoods)
    render json: JSON.dump("fws" => firewoods)
  end

  def render_fws_and_users(firewoods, users)
    render json: JSON.dump("fws" => firewoods, "users" => users)
  end
end
