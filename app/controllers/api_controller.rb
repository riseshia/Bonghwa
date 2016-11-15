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
      adult_check: params[:adult_check]
    )

    render_empty_json
  end

  def create_cmd
    firewood = Firewood.create(
      user_id: @user.id,
      user_name: @user.name,
      prev_mt: params[:firewood][:prev_mt],
      contents: params[:firewood][:contents],
      attached_file: params[:attach],
      adult_check: params[:adult_check]
    )
    Scripter.execute(firewood: firewood, user: @user, app: @app)

    render_empty_json
  end

  def create_dm
    contents = params[:firewood][:contents]
    fw_parsed = contents.match('^!(\S+)\s(.+)') # parsing
    enable_to_send = true
    message = ""
    if fw_parsed.nil?
      message = "잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 양식으로 작성해주세요."
      enable_to_send = false
    else
      dm_user = User.find_by(name: fw_parsed[1]) # user check
      if dm_user.nil?
        message = "존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요."
        enable_to_send = false
      end
    end

    Firewood.create(
      user_id: @user.id,
      user_name: @user.name,
      prev_mt: params[:firewood][:prev_mt],
      contents: params[:firewood][:contents],
      attached_file: params[:attach],
      adult_check: params[:adult_check],
      is_dm: enable_to_send ? dm_user.id : @user.id
    )

    Firewood.system_dm(user_id: @user.id, message: message) \
      if !enable_to_send && @user.id.nonzero?

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
  def mts
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
    users = recent_users

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
