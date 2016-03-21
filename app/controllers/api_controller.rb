# frozen_string_literal: true
# ApiController
class ApiController < ApplicationController
  def create
    @fw = Firewood.new(
      user_id: @user.id,
      user_name: @user.name,
      prev_mt: params[:firewood][:prev_mt],
      contents: escape_tags(params[:firewood][:contents]),
      attached_file: params[:attach],
      adult_check: params[:adult_check],
      app: @app,
      user: @user
    )

    @fw.save

    render_result request
  end

  def destroy
    @fw = Firewood.find(params[:id])
    @fw.destroy if @fw.editable? @user

    render_result request
  end

  # 지금 시점으로부터 가장 최근의 장작을 50개 불러온다.
  def now
    type = params[:type]
    @firewoods = if type == "1" # Now
                   Firewood.timeline_with_cache(@user)
                 elsif type == "2" # Mt
                   Firewood.where("is_dm = ? OR contents like ?", session[:user_id], "%@" + session[:user_name] + "%").order("id DESC").limit(50)
                 elsif type == "3" # Me
                   Firewood.where("user_id = ?", session[:user_id]).order("id DESC").limit(50)
                 end.map(&:to_hash_for_api)

    update_login_info(@user)
    @users = get_recent_users

    render_result request, "fws" => @firewoods, "users" => @users
  end

  # 지정한 멘션의 루트를 가지는 것을 최근 것부터 1개 긁어서 json으로 돌려준다.
  def get_mt
    @mts = Firewood.find_mt(params[:prev_mt], session[:user_id]).map(&:to_hash_for_api)

    render_result request, "fws" => @mts
  end

  # after 이후의 장작을 최대 1000개까지 내림차순으로 받아온다.
  def pulling
    type = params[:type]

    @fws = if type == "1" # Now
             Firewood.after_than(params[:after])
           elsif type == "2" # Mt
             Firewood.where("id > ? AND (is_dm = ? OR contents like ?)", params[:after], session[:user_id], "%@" + session[:user_name] + "%").order("id DESC").limit(1000)
           elsif type == "3" # Me
             Firewood.where("id > ? AND user_id = ?", params[:after], session[:user_id]).order("id DESC").limit(1000)
           end.map(&:to_hash_for_api)
    update_login_info(@user)
    @users = get_recent_users

    render_result request, "fws" => @fws, "users" => @users
  end

  def trace
    limit = limit_count_to_50 params[:count].to_i # Limit maximum size

    type = params[:type]

    @fws = if type == "1" # Now
             Firewood.where("id < ? AND (is_dm = 0 OR is_dm = ? OR user_id = ?)", params[:before], session[:user_id], session[:user_id]).order("id DESC").limit(limit)
           elsif type == "2" # Mt
             Firewood.where("id < ? AND (is_dm = ? OR contents like ?)", params[:before], session[:user_id], "%@" + session[:user_name] + "%").order("id DESC").limit(limit)
           elsif type == "3" # Me
             Firewood.where("id < ? AND user_id = ?", params[:before], session[:user_id]).order("id DESC").limit(limit)
           end.map(&:to_hash_for_api)

    render_result request, "fws" => @fws, "users" => @users
  end

  private

  def limit_count_to_50(number)
    number > 50 ? 50 : number
  end

  def render_result(request, hash = {})
    if request.xhr?
      render json: JSON.dump(hash.empty? ? "" : hash)
    else
      render inline: "<textarea>" + (hash.empty? ? "" : hash) + "</textarea>"
    end
  end

  def escape_tags(str)
    str.gsub("<", "&lt;").gsub(">", "&gt;")
  end
end
