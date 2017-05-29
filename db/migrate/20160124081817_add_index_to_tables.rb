class AddIndexToTables < ActiveRecord::Migration[4.2]
  def change
    add_index :firewoods, :attach_id
    add_index :firewoods, :user_id
  end
end
