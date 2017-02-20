class AddIndexToFirewoods < ActiveRecord::Migration[5.0]
  def change
    remove_column :firewoods, :attach_id, :integer

    add_index :firewoods, :prev_mt_id
    add_index :firewoods, :root_mt_id
    add_index :firewoods, :is_dm
  end
end
