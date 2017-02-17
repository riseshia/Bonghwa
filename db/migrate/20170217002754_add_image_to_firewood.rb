class AddImageToFirewood < ActiveRecord::Migration[5.0]
  def change
    add_column :firewoods, :image, :string
    add_column :firewoods, :image_adult_flg, :boolean, default: false, null: false

    remove_index :firewoods, :attach_id
    drop_table :attaches
  end
end
