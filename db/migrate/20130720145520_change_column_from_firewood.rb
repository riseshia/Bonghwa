class ChangeColumnFromFirewood < ActiveRecord::Migration[4.2]
  def change
  	rename_column :firewoods, :img_id, :attach_id
  end
end
