# ViewController
class ViewController < ApplicationController
  def timeline
    @new_fw = Firewood.new
    @infos = get_info
  end

  def get_info
    @infos = []
    if redis.zcard("#{servername}:app-infos") == 0
      @infos = Info.all
      @infos.each do |info|
        redis.zadd("#{servername}:app-infos", info.id, info.to_json)
      end
    else
      infos = redis.zrange("#{servername}:app-infos", 0, -1)
      infos.each do |info|
        @infos << Info.from_json(JSON.parse(info))
      end
    end

    @infos
  end
end
