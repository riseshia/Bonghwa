class Attach < ActiveRecord::Base
  attr_accessible :img
  has_attached_file :img,
                    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
                    url: '/system/:attachment/:id/:style/:filename'

  has_one :firewood

  validates_attachment_size :img, less_than: 3.megabytes
  validates_attachment_content_type :img, content_type: [/^image\/(?:jpeg|gif|png)$/, nil]

  before_create do |before|
    before.img_file_name = before.img_file_name.delete('\'')
  end
end
