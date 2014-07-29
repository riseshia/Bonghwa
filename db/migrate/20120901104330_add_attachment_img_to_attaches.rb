class AddAttachmentImgToAttaches < ActiveRecord::Migration
  def self.up
    change_table :attaches do |t|
      t.has_attached_file :img
    end
  end

  def self.down
    drop_attached_file :attaches, :img
  end
end