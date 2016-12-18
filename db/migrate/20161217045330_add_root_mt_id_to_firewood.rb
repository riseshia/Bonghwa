class AddRootMtIdToFirewood < ActiveRecord::Migration[5.0]
  def change
    add_column :firewoods, :root_mt_id, :integer, default: 0
  end
end
