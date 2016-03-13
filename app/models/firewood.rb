# Firewood
class Firewood < ActiveRecord::Base
  # Callback
  before_create :default_values
  before_destroy :destroy_attach
  after_save :add_to_redis
  after_destroy :remove_from_redis

  belongs_to :user
  belongs_to :attach

  # Scope
  def self.find_mt(prev_mt, user_id)
    where('(id = ?) AND (is_dm = 0 OR is_dm = ?)', prev_mt, user_id).order('id DESC').limit(1)
  end

  # Public Method
  def self.timeline_with_cache(user)
    firewoods = $redis.zrange("#{$servername}:fws", 0, -1).map do |fw|
      Firewood.new(JSON.parse(fw))
    end.select do |fw|
      fw.visible? user.id
    end
  end

  def self.after_than(after_id)
    $redis.zrevrangebyscore("#{$servername}:fws", '+inf', "(#{after_id}").map do |fw|
      Firewood.new(JSON.parse(fw))
    end
  end

  def normal?
    is_dm == 0
  end

  def visible?(session_user_id)
    normal? || is_dm == session_user_id || user_id == session_user_id
  end

  def to_hash_for_api
    {
      'id' => id, 'is_dm' => is_dm,
      'mt_root' => mt_root,
      'prev_mt' => prev_mt,
      'user_id' => user_id,
      'name' => user_name,
      'contents' => contents,
      'img_link' => img_link,
      'created_at' => created_at.strftime('%D %T')
    }
  end

  def img_link
    attach_id != 0 ? attach.img.url : '0'
  end

  def editable?(user)
    user_id == user.id
  end

  def save_fw(params)
    fw = self
    begin
      fail '내용이 없습니다.' if fw.contents.size == 0 && params[:attach].size == 0

      Firewood.transaction do
        unless params[:attach].blank?
          @attach = Attach.create!(img: params[:attach])
          fw.attach_id = @attach.id
          if params[:adult_check]
            fw.contents += " <span class='has-image text-warning'>[후방주의 #{@attach.id}]</span>"
          else
            fw.contents += " <span class='has-image'>[이미지 #{@attach.id}]</span>"
          end
        end

        fw.save!
      end
    rescue Exception => e
    end

    fw
  end

  def save_dm(params)
    fw = self
    # parsing
    fw_parsed = fw.contents.match('^!(\S+)\s(.+)')

    unless fw_parsed
      Firewood.system_dm attach: params[:attach], adult_check: params[:adult_check], user_id: params[:user_id], message: "잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 양식으로 작성해주세요."
      return false
    end

    # user_check
    dm_user = User.find_by_name(fw_parsed[1])
    unless dm_user
      Firewood.system_dm attach: params[:attach], adult_check: params[:adult_check], user_id: params[:user_id], message: '존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요.'
      return false
    end
    fw.is_dm = dm_user.id

    fw.save_fw params
  end

  def save_cmd(user, app, params)
    @user = user
    fw = self
    fw_parsed = fw.contents.match('^!(\S+)\s(.+)')

    fw.save_fw attach: params[:attach], adult_check: params[:adult_check]

    # command
    fw.script_excute(@user, app, params)
  end

  def script_excute(user, app, params)
    @app = app
    str = contents

    @fw = Firewood.new
    @fw.user_id = 0
    @fw.user_name = 'System'
    arr = str.split(' ').reject do |el|
      el.start_with?('#')
    end
    str = arr.join(' ')

    @fw.contents = admin_script_excute(str, user)
    if @fw.contents.size != 0
      # 관리자 명령
    elsif @app.use_script == 0 # 유저 명령 비활성.
      @fw.contents = '명령어가 비활성화되어있습니다.'
    else # 이외는 전부 유저 명령
      @fw.contents = user_script_excute(str, user)
    end

    @fw.save_fw attach: params[:attach], adult_check: params[:adult_check]
  end

  # Class Method
  def self.system_dm(params)
    Firewood.new(
      user_id: 0,
      user_name: 'System',
      contents: params[:message],
      is_dm: params[:user_id]
    ).save_fw attach: params[:attach], adult_check: params[:adult_check]
  end

  private

  def redis
    $redis
  end

  def servername
    $servername
  end

  def user_script_excute(str, user)
    user = User.find(user.id)
    arr = str.split(' ')

    if arr[0] == '/주사위'
      if arr.size == 2
        dice_size = arr[1].to_i
        if dice_size > 1 && dice_size < 101
          "#{rand(1..dice_size)}이(가) 나왔습니다."
        else
          '인수 지정이 잘못되었습니다. 2에서 100 사이의 자연수를 입력해주세요.'
        end
      elsif arr.size > 2
        "명령어는 '/주사위 {면수:생략시 6}'입니다."
      else
        "#{rand(1..6)}이(가) 나왔습니다."
      end
    elsif arr[0] == '/코인'
      if arr.size > 1
        "명령어는 '/코인'입니다."
      else
        coin = rand(1..2)
        "#{coin == 1 ? '앞면' : '뒷면'}이 나왔습니다."
      end
    elsif /\/[0-9]+d[0-9]+/.match(str) # n면 dice r개
      arr = str.split(/\/|d/)
      n = arr[1].to_i
      r = arr[2].to_i
      if n > 1 && n < 51 && r > 0 && r < 21
        result = ''
        for i in 1...r
          result += "#{rand(1..n)}, "
        end
        result + "#{rand(1..n)} 의 주사위 눈이 나왔습니다."
      else
        '2면에서 50면, 1개에서 20개의 주사위를 굴리실 수 있습니다.'
      end
    elsif arr[0] == '/등수'
      if arr.size > 1
        "등수 명령어에는 추가적인 인수가 필요하지 않습니다. '/등수'라고 명령해주세요."
      else
        rs = Firewood.select('user_name, count(*) as count')
                     .where('created_at > ?', Time.zone.now - 1.month)
                     .group('user_id')
                     .order('count DESC')
                     .limit(5)
        str = ''
        i = 1
        rs.each do |r|
          str += i.to_s + '위: ' + r.user_name + ', ' + r.count.to_s + '개. '
          i += 1
        end
        str
      end
    elsif arr[0] == '/내등수'
      if arr.size > 1
        "등수 명령어에는 추가적인 인수가 필요하지 않습니다. '/내등수'라고 명령해주세요."
      else
        rs = Firewood.select('user_id, count(*) as count')
                     .where('created_at > ?', Time.zone.now - 1.month)
                     .group('user_id')
                     .order('count DESC, user_id ASC')

        rank = 0
        rs.each do |r|
          break if r.user_id == user.id
          rank += 1
        end

        "#{user.name}님이 던지신 장작은 #{rs[rank].count}개로, 현재 #{rank + 1}등 입니다."
      end
    elsif arr[0] == '/닉'
      if arr.size != 2
        "이 명령어에는 하나의 인수가 필요합니다. '/닉 [변경할 닉네임]'라고 명령해주세요. 변경할 닉네임에는 공백 허용되지 않습니다."
      else
        exist = true if User.find_by_name(arr[1]) || arr[1] == 'System'

        if arr[1] == user.name
          '변경하실 닉네임이 같습니다. 다른 닉네임으로 시도해 주세요.'
        elsif exist
          '해당하는 닉네임은 이미 존재합니다.'
        else
          before_user_name = user.name

          user.name = arr[1]
          user.save!

          $redis.zrem("#{$servername}:active-users", before_user_name)
          $redis.zadd("#{$servername}:active-users", Time.zone.now.to_i, user.name)
          $redis.set("#{$servername}:session-#{session[:user_id]}", user.to_json)
          $redis.expire("#{$servername}:session-#{session[:user_id]}", 86_400)

          setup_session user
          cookies[:user_name] = { value: user.name, expires: Time.zone.now + 7.days }

          "#{before_user_name}님의 닉네임이 #{user.name}로 변경되었습니다."
        end
      end
    else
      '존재하지 않는 명령어입니다.'
    end
  end

  def admin_script_excute(str, user)
    arr = str.split(' ')
    if arr[0] == '/공지추가'
      if user.level == 999
        im = str.gsub('/공지추가 ', '')
        if str.gsub('/공지추가', '').size == 0
          '내용을 입력해주세요.'
        else
          info = Info.create!(infomation: im)
          '공지가 등록되었습니다.'
        end
      else
        '권한이 없습니다.'
      end
    elsif arr[0] == '/공지삭제'
      if user.level == 999
        if arr.size == 1
          '삭제할 공지의 id를 주셔야합니다.'
        else
          infos = Info.all_with_cache

          if infos.nil?
            '공지사항이 없네요.'
          elsif infos.size < arr[2].to_i
            '공지사항이 없어요.'
          else
            deleted_idx = arr[1].to_i - 1
            infos[deleted_idx].destroy
            '삭제 완료되었습니다.'
          end
        end
      else
        '권한이 없습니다.'
      end
    else
      ''
    end
  end

  def add_to_redis
    $redis.zadd("#{$servername}:fws", self.id, self.to_json)
    $redis.zremrangebyrank("#{$servername}:fws", 0, 0) if self.normal?
  end

  def remove_from_redis
    $redis.zremrangebyscore("#{$servername}:fws", self.id, self.id)

    if self.normal?
      idx = JSON.parse($redis.zrange("#{$servername}:fws", 0, 0).first)['id'] - 1
      loop do
        fw = Firewood.find(idx)
        if fw.nil?
          idx -= 1
          next
        end

        $redis.zadd("#{$servername}:fws", fw.id, fw.to_json)
        break if self.normal?
      end
    end
  end

  def default_values
    self.is_dm ||= 0
    self.attach_id ||= 0
    self.mt_root ||= 0
  end

  def destroy_attach
    self.attach.destroy if self.attach.present?
  end
end
