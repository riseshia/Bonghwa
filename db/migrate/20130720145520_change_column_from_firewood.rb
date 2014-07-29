class ChangeColumnFromFirewood < ActiveRecord::Migration
  def change
  	rename_column :firewoods, :img_id, :attach_id
  end
end
