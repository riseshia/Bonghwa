FactoryGirl.define do
  factory :normal_message, class: Firewood do
    attach_id 0
    is_dm 0
    mt_root 0
    contents 'Yeahey!'
    prev_mt '0'
    user_id 1
    user_name 'user'
  end

  factory :dm_message_to_user1, class: Firewood do
    attach_id 0
    is_dm 1000
    mt_root 0
    contents '!user_name Yeahey!'
    prev_mt '0'
    user_id 2000
    user_name 'user'
  end
end
