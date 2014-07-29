class AddPrevMtToFirewoods < ActiveRecord::Migration
  def change
    add_column :firewoods, :prev_mt, :integer, default: 0
  end
end
