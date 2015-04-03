#encoding: utf-8

class ApplicationController < ActionController::Base
  before_filter :authorize, :app_setting
  protect_from_forgery
  
  protected
    def app_setting
      @app = $redis.get("#{$servername}:app-data")
      if @app
        @app = Marshal.load(@app)
      else
        @app = App.first
        $redis.set("#{$servername}:app-data", Marshal.dump(@app))
      end

      if @app == nil
        redirect_to initialize_path
      else
        @links = []
        if $redis.zcard("#{$servername}:app-links") == 0
          @links = Link.all
          @links.each do |link|
            $redis.zadd("#{$servername}:app-links", link.id, Marshal.dump(link))
          end
        else
          links = $redis.zrange("#{$servername}:app-links",0,-1)
          links.each do |link|
            @links << Marshal.load(link)
          end
        end
        return true
      end
    end

  protected
    def authorize
      @user = $redis.get("#{$servername}:session-#{session[:user_id]}")
      
      if @user
        @user = Marshal.load(@user)
      else
        @user = User.find_by_id(session[:user_id])
        $redis.set("#{$servername}:session-#{session[:user_id]}", Marshal.dump(@user))
        $redis.expire("#{$servername}:session-#{session[:user_id]}", 86400)
      end

      if @user == nil
        redirect_to login_path, notice: "로그인해주세요."
      elsif @user.level < 1
        session[:user_id]  = nil
        session[:user_name] = nil
        session[:user_level] = nil
        
        redirect_to login_path, notice: "가입 대기 상태입니다. 관리자에게 문의해주세요."
      else
        session[:user_name] = @user.name
        session[:user_level] = @user.level
      end
    end
    
  protected
    def admin_check
      if @user == nil
        redirect_to login_path, notice: "로그인해주세요."
      elsif @user.level != 999
        redirect_to index_path, notice: "접근 권한이 없습니다. 관리자에게 문의해주세요."
      end
    end

  protected
    def to_json (firewoods)
      fws = []
      firewoods.each do |fw|
        img_link = "0"
        if(fw.attach_id != 0)
          img_link = fw.attach.img.url
        end

        a = {
          'id' => fw.id,
          'mt_root' => fw.mt_root,
          'prev_mt' => fw.prev_mt,
          'is_dm' => fw.is_dm,
          'user_id' => fw.user_id,
          'name' => fw.user_name,
          'contents' => fw.contents,
          'img_link' => img_link,
          'created_at' => fw.created_at.strftime("%D %T")
        }
        fws << a
      end
      return fws
    end

  protected
    def update_login_info(user)
      $redis.zadd("#{$servername}:active-users", Time.now.to_i, user.name) unless user.id == 1
    end

  protected
    def get_recent_users
      now_timestamp = Time.now.to_i
      before_timestamp = now_timestamp - 40
      @users = $redis.zrangebyscore("#{$servername}:active-users",before_timestamp,now_timestamp)

      users = []
      @users.sort.each do |user|
        users << {'name' => user}
      end

      return users
    end

  protected
    def save_fw(fw)
      begin
        raise "내용이 없습니다." if fw.contents.size == 0 and params[:attach].size == 0

        Firewood.transaction do
          unless params[:attach].blank?
            @attach = Attach.create!(:img => params[:attach])
            fw.attach_id = @attach.id
            if params[:adult_check]
              fw.contents += " <span class='has-image text-warning'>[후방주의 #{@attach.id}]</span>"
            else
              fw.contents += " <span class='has-image'>[이미지 #{@attach.id}]</span>"
            end
          end
          
          fw.save!
        end

        $redis.zadd("#{$servername}:fws",fw.id,Marshal.dump(fw))
        $redis.zremrangebyrank("#{$servername}:fws",0,-1*($redis_cache_size-1))
      rescue Exception => e
        log = e.message
      end
      log = "정상적으로 업로드 되었습니다."
    end

  protected
    def escape_tags(str)
      a = str.gsub('<', '&lt;')
      str = a.gsub('>', '&gt;')
      
      return str
    end

  protected
    def script_excute(str)
      @fw = Firewood.new
      @fw.user_id = 0
      @fw.user_name = "System"
      # @fw.rgb = "0,0,0"
      arr = str.split(' ')
      arr = arr.reject do |el|
        el.start_with?("#")
      end
      str = arr.join(' ')
      
      @fw.contents = admin_script_excute(str)
      if @fw.contents.size != 0
        # 관리자 명령
      elsif @app.use_script == 0 # 유저 명령 비활성.
        @fw.contents = "명령어가 비활성화되어있습니다."
      else # 이외는 전부 유저 명령
        @fw.contents = user_script_excute(str)
      end

      save_fw(@fw)
    end

  protected
    def user_script_excute(str)
      arr = str.split(' ')
      result_str = ""
      if arr[0] == "/주사위"
        if arr.size == 2
          dice_size = arr[1].to_i
          if dice_size > 1 and dice_size < 101
            result_str = "#{rand(1..dice_size)}이(가) 나왔습니다."
          else
            result_str = "인수 지정이 잘못되었습니다. 2에서 100 사이의 자연수를 입력해주세요."
          end
        elsif arr.size > 2
          result_str = "명령어는 '/주사위 {면수:생략시 6}'입니다."
        else
          result_str = "#{rand(1..6)}이(가) 나왔습니다."
        end
      elsif arr[0] == "/코인"
        if arr.size > 1
          result_str = "명령어는 '/코인'입니다."
        else
          coin = rand(1..2)
          result_str = "#{coin==1?'앞면':'뒷면'}이 나왔습니다."
        end
      elsif /\/[0-9]+d[0-9]+/.match(str) #n면 dice r개
        arr = str.split(/\/|d/)
        n = arr[1].to_i
        r = arr[2].to_i
        result = ""
        if n > 1 and n < 51 and r > 0 and r < 21
          for i in 1...r
            result += "#{rand(1..n)}, "
          end
          result_str = result + "#{rand(1..n)} 의 주사위 눈이 나왔습니다."
        else
          result_str = "2면에서 50면, 1개에서 20개의 주사위를 굴리실 수 있습니다."
        end
      elsif arr[0] == "/등수"
        if arr.size > 1
          result_str = "등수 명령어에는 추가적인 인수가 필요하지 않습니다. '/등수'라고 명령해주세요."
        else
          rs = Firewood.select("user_name, count(*) as count")
                       .where("created_at > ?",Time.now-1.month)
                       .group("user_id")
                       .order("count DESC")
                       .limit(5)
          str = ""
          i = 1
          rs.each do |r|
            str += i.to_s + "위: " + r.user_name + ", " + r.count.to_s + "개. "
            i += 1
          end
          result_str = str
        end
      elsif arr[0] == "/내등수"
        if arr.size > 1
          result_str = "등수 명령어에는 추가적인 인수가 필요하지 않습니다. '/내등수'라고 명령해주세요."
        else
          rs = Firewood.select("user_id, count(*) as count")
             .where("created_at > ?",Time.now-1.month)
             .group("user_id")
             .order("count DESC, user_id ASC")

          rank = 0
          rs.each do |r|
            break if r.user_id == @user.id
            rank += 1
          end
          
          result_str = "#{@user.name}님이 던지신 장작은 #{rs[rank].count}개로, 현재 #{rank+1}등 입니다."
        end
      elsif arr[0] == "/닉"
        if arr.size != 2
          result_str = "이 명령어에는 하나의 인수가 필요합니다. '/닉 [변경할 닉네임]'라고 명령해주세요. 변경할 닉네임에는 공백 허용되지 않습니다."
        else
          exist = User.find_by_name(arr[1])
          exist = true if arr[1] == "System"

          if arr[1] == @user.name
            result_str = "변경하실 닉네임이 같습니다. 다른 닉네임으로 시도해 주세요."
          elsif exist
            result_str = "해당하는 닉네임은 이미 존재합니다."
          else
            before = @user.name

            @user.name = arr[1]
            @user.save!
            
            $redis.zrem("#{$servername}:active-users", before)
            $redis.zadd("#{$servername}:active-users", Time.now.to_i, @user.name)
            $redis.set("#{$servername}:session-#{session[:user_id]}", Marshal.dump(@user))
            $redis.expire("#{$servername}:session-#{session[:user_id]}", 86400)

            session[:user_name] = @user.name
            cookies[:user_name] = { value: @user.name, expires: realTime() + 7.days}

            result_str = "#{before}님의 닉네임이 #{@user.name}로 변경되었습니다."
          end
        end
      else
        result_str = "존재하지 않는 명령어입니다."
      end

      return result_str
    end

  protected
    def admin_script_excute(str)
      arr = str.split(' ')
      result_str = ""
      if arr[0] == "/공지추가"
        if @user.level == 999
          im = str.gsub("/공지추가 ", "")
          if str.gsub("/공지추가", "").size == 0
            result_str = "내용을 입력해주세요."
          else
            info = Info.new
            info.infomation = im
            info.save!
            $redis.zadd("#{$servername}:app-infos", info.id, Marshal.dump(info))

            result_str = "공지가 등록되었습니다."
          end
        else
          result_str = "권한이 없습니다."
        end
      elsif arr[0] == "/공지삭제"
        if @user.level == 999
          if arr.size == 1
            result_str = "삭제할 공지의 id를 주셔야합니다."
          else
            infos = Info.all

            if(infos == nil)
              result_str = "공지사항이 없네요."
            elsif(infos.size < arr[2].to_i)
              result_str = "공지사항이 없어요."
            else
              deleted_idx = arr[1].to_i-1
              $redis.zremrangebyscore("#{$servername}:app-infos", infos[deleted_idx].id, infos[deleted_idx].id)
              infos[deleted_idx].delete
              result_str = "삭제 완료되었습니다."
            end
          end
        else
          result_str = "권한이 없습니다."
        end
      end

      return result_str
    end

  protected
    def realTime
      return Time.zone.now + 9.hours
    end
end
