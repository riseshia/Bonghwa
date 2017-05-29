class AddPrevMtToFirewoods < ActiveRecord::Migration[4.2]
  def change
    add_column :firewoods, :prev_mt, :integer, default: 0
  end
end
