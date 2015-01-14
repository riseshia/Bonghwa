FactoryGirl.define do
  factory :user do
    login_id  "user_id"
    name      "user_name"
    password  "userpwd"
    password_confirmation "userpwd"
    level     "1"
  end

  factory :admin, class: User do
    login_id  "admin"
    name      "administrator"
    password  "userpwd"
    password_confirmation "userpwd"
    level     "999"  
  end
end