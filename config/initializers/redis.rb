begin
  RedisWrapper.setup

  last = Firewood.where(is_dm: 0).order(id: :desc).offset(50).limit(1).first
  if last.present?
    Firewood.where('id > ?', last.id).each do |fw|
      RedisWrapper.zadd("fws", fw.id, fw.to_json)
    end
  end
rescue
end
