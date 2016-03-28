# frozen_string_literal: true
FactoryGirl.define do
  factory :app, class: App do
    home_name "Bonghwa"
    home_link "/"
    app_name "Bonghwa"
    use_script 1
  end
end
