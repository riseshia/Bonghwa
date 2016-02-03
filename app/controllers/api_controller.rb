# ApiController
class ApiController < ApplicationController
  def new
    @fw = Firewood.new(firewood_params) do |fw|
      fw.user_id ||= @user.id
      fw.user_name = session[:user_name]
      fw.prev_mt ||= 0
      fw.contents = escape_tags(fw.contents)
    end

    if @fw.contents.match('^!.+')
      new_dm(@fw)
    elsif @fw.contents.match('^/.+')
      new_cmd(@fw)
    else
      save_fw(@fw)
    end

    if request.xhr?
      render json: Oj.dump('')
    else
      render inline: '<textarea>{}</textarea>'
    end
  end

  def new_dm(fw)
    # parsing
    fw_parsed = fw.contents.match('^!(\S+)\s(.+)')

    unless fw_parsed
      system_dm("잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 양식으로 작성해주세요.")
      return
    end

    # user_check
    dm_user = User.find_by_name(fw_parsed[1])
    unless dm_user
      system_dm('존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요.')
      return
    end
    fw.is_dm = dm_user.id

    save_fw(fw)
  end

  def new_cmd(fw)
    fw_parsed = fw.contents.match('^!(\S+)\s(.+)')

    save_fw(fw)

    # command
    script_excute(fw.contents)
  end

  def system_dm(message)
    @dm = Firewood.new do
      user_id 0
      user_name 'System'
      contents message
      is_dm session[:user_id]
    end

    save_fw(@dm)
  end

  def destroy
    @fw = Firewood.find(params[:id])

    # 삭제 권한(자기 자신)이 있는지 확인
    if @fw.editable? @user
      redis.zremrangebyscore("#{servername}:fws", @fw.id, @fw.id)
      @fw.destroy
    end

    if request.xhr?
      render json: Oj.dump('')
    else
      render inline: '<textarea>{}</textarea>'
    end
  end

  # 지금 시점으로부터 가장 최근의 장작을 50개 불러온다.
  def now
    type = params[:type]
    @firewoods = []

    if type == '1' # Now
      count = 0
      redis.zrevrange("#{servername}:fws", 0, 500).each do |fw|
        f = Marshal.load(fw)
        if f.normal? || f.is_dm == session[:user_id] || f.user_id == session[:user_id]
          @firewoods << f
          count += 1
        end
        break if count == 50
      end
    elsif type == '2' # Mt
      @firewoods = Firewood.where('is_dm = ? OR contents like ?', session[:user_id], '%@' + session[:user_name] + '%').order('id DESC').limit(50)
    elsif type == '3' # Me
      @firewoods = Firewood.where('user_id = ?', session[:user_id]).order('id DESC').limit(50)
    end
    @fws = @firewoods.map(&:to_json)

    update_login_info(@user)
    @users = get_recent_users

    if request.xhr?
      render json: Oj.dump('fws' => @fws, 'users' => @users)
    else
      render inline: "<textarea><%= Oj.dump('fws' => @fws, 'users' => @users) %></textarea>"
    end
  end

  # 지정한 멘션의 루트를 가지는 것을 최근 것부터 1개 긁어서 json으로 돌려준다.
  def get_mt
    @mts = Firewood.find_mt(params[:prev_mt], session[:user_id]).map(&:to_json)

    if request.xhr?
      render json: Oj.dump('fws' => @mts)
    else
      render inline: "<textarea><%= Oj.dump('fws' => @mts) %></textarea>"
    end
  end

  # after 이후의 장작을 최대 1000개까지 내림차순으로 받아온다.
  def pulling
    type = params[:type]

    @firewoods = if type == '1' # Now
      redis.zrevrangebyscore("#{servername}:fws", '+inf', "(#{params[:after]}").select do |fw|
        f = Marshal.load(fw)
        f.normal? || f.is_dm == session[:user_id] || f.user_id == session[:user_id]
      end
    elsif type == '2' # Mt
      Firewood.where('id > ? AND (is_dm = ? OR contents like ?)', params[:after], session[:user_id], '%@' + session[:user_name] + '%').order('id DESC').limit(1000)
    elsif type == '3' # Me
      Firewood.where('id > ? AND user_id = ?', params[:after], session[:user_id]).order('id DESC').limit(1000)
    end

    @fws = @firewoods.map(&:to_json)

    update_login_info(@user)
    @users = get_recent_users

    if request.xhr?
      render json: Oj.dump('fws' => @fws, 'users' => @users)
    else
      render inline: "<textarea><%= Oj.dump('fws' => @fws, 'users' => @users) %></textarea>"
    end
  end

  def trace
    limit = params[:count]
    limit = 50 if limit.to_i > 50 # 최대값 제한.

    type = params[:type]
    @firewoods = nil

    if type == '1' # Now
      @firewoods = Firewood.where('id < ? AND (is_dm = 0 OR is_dm = ? OR user_id = ?)', params[:before], session[:user_id], session[:user_id]).order('id DESC').limit(limit)
    elsif type == '2' # Mt
      @firewoods = Firewood.where('id < ? AND (is_dm = ? OR contents like ?)', params[:before], session[:user_id], '%@' + session[:user_name] + '%').order('id DESC').limit(limit)
    elsif type == '3' # Me
      @firewoods = Firewood.where('id < ? AND user_id = ?', params[:before], session[:user_id]).order('id DESC').limit(limit)
    end
    @fws = @firewoods.map(&:to_json)

    if request.xhr?
      render json: Oj.dump('fws' => @fws, 'users' => @users)
    else
      render inline: "<textarea><%= Oj.dump('fws' => @fws, 'users' => @users) %></textarea>"
    end
  end

  private

  def firewood_params
    params.require(:firewood).permit(:contents, :prev_mt)
  end
end
