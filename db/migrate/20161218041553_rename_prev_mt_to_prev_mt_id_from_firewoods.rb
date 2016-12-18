class RenamePrevMtToPrevMtIdFromFirewoods < ActiveRecord::Migration[5.0]
  def change
    rename_column :firewoods, :prev_mt, :prev_mt_id
  end
end
