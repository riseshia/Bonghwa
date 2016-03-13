FactoryGirl.define do
  factory :user, class: User do
    id '1000'
    login_id 'user_id'
    name 'user_name'
    password 'userpwd'
    password_confirmation 'userpwd'
    level '1'
  end

  factory :user2, class: User do
    id '2000'
    login_id 'user_id2'
    name 'user_name2'
    password 'userpwd2'
    password_confirmation 'userpwd2'
    level '1'
  end

  factory :admin, class: User do
    login_id 'admin'
    name 'administrator'
    password 'userpwd'
    password_confirmation 'userpwd'
    level '999'
  end
end
