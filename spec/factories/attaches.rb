# frozen_string_literal: true
FactoryGirl.define do
  factory :attach, class: Attach do
    img_file_name "file_name"
    img_content_type "image/jpeg"
    img_file_size 400
  end
end
