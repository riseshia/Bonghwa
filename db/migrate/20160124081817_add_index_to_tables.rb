class AddIndexToTables < ActiveRecord::Migration
  def change
    add_index :firewoods, :attach_id
    add_index :firewoods, :user_id
  end
end
