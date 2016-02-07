# ApplicationController
class ApplicationController < ActionController::Base
  before_action :authorize, :app_setting
  protect_from_forgery with: :exception

  protected

  def app_setting
    @app = redis.get("#{servername}:app-data")
    if @app
      @app = Marshal.load(@app)
    else
      @app = App.first
      redis.set("#{servername}:app-data", Marshal.dump(@app))
    end

    if @app.nil?
      redirect_to initialize_path
    else
      @links = []
      if redis.zcard("#{servername}:app-links") == 0
        @links = Link.all
        @links.each do |link|
          redis.zadd("#{servername}:app-links", link.id, Marshal.dump(link))
        end
      else
        links = redis.zrange("#{servername}:app-links", 0, -1)
        links.each do |link|
          @links << Marshal.load(link)
        end
      end
      return true
    end
  end

  def authorize
    @user = redis.get("#{servername}:session-#{session[:user_id]}")

    if @user
      @user = Marshal.load(@user)
    else
      @user = User.find_by_id(session[:user_id])
      redis.set("#{servername}:session-#{session[:user_id]}", Marshal.dump(@user))
      redis.expire("#{servername}:session-#{session[:user_id]}", 86_400)
    end

    if @user.nil?
      redirect_to login_path, notice: '로그인해주세요.'
    elsif @user.level < 1
      remove_session

      redirect_to login_path, notice: '가입 대기 상태입니다. 관리자에게 문의해주세요.'
    else
      setup_session @user.id, @user.name, @user.level
      cookies[:user_name] = { value: @user.name, expires: real_time + 7.days }
    end
  end

  def admin_check
    if @user.nil?
      redirect_to login_path, notice: '로그인해주세요.'
    elsif @user.level != 999
      redirect_to index_path, notice: '접근 권한이 없습니다. 관리자에게 문의해주세요.'
    end
  end

  def update_login_info(user)
    redis.zadd("#{servername}:active-users", Time.zone.now.to_i, user.name) unless user.id == 1
  end

  def get_recent_users
    now_timestamp = Time.zone.now.to_i
    before_timestamp = now_timestamp - 40
    @users = redis.zrangebyscore("#{servername}:active-users", before_timestamp, now_timestamp)

    @users.sort.map do |user|
      { 'name' => user }
    end
  end

  def real_time
    Time.zone.now + 9.hours
  end

  # global redis accessor
  def redis
    $redis
  end

  # global servername accessor
  def servername
    $servername
  end

  def remove_session
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_level] = nil
  end

  def setup_session(user_id, user_name, user_level)
    session[:user_id] = user_id
    session[:user_name] = user_name
    session[:user_level] = user_level
  end    
end
