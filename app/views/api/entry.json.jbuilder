json.set! :fws do
  json.array! firewoods do |fw|
    json.id fw.id
    json.is_dm fw.is_dm
    json.prev_mt_id fw.prev_mt_id
    json.root_mt_id fw.root_mt_id
    json.user_id fw.user_id
    json.name fw.user_name
    json.contents fw.contents
    json.img_id fw.attach_id
    json.img_adult_flg fw.attach&.adult_flg
    json.img_link fw.img_link
    json.created_at fw.formatted_created_at
  end
end
json.users users
json.set! :infos do
  json.array! infos do |info|
    json.id info.id
    json.information info.infomation
  end
end
