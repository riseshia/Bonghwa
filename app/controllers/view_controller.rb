class ViewController < ApplicationController
  def now
    @new_fw = Firewood.new
    @infos = get_info
  end

  def lab
    @new_fw = Firewood.new
    @infos = get_info
  end

  def mt
    @new_fw = Firewood.new
    @infos = get_info
  end

  def me
    @new_fw = Firewood.new
    @infos = get_info
  end

  def option
  end

  def help
  end

  def get_info
    @infos = []
    if $redis.zcard("#{$servername}:app-infos") == 0
      @infos = Info.all
      @infos.each do |info|
        $redis.zadd("#{$servername}:app-infos", info.id, Marshal.dump(info))
      end
    else
      infos = $redis.zrange("#{$servername}:app-infos",0,-1)
      infos.each do |info|
        @infos << Marshal.load(info)
      end
    end

    return @infos
  end
end
