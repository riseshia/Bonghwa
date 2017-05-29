class CreateFirewoods < ActiveRecord::Migration[4.2]
  def change
    create_table :firewoods do |t|
      t.string :contents
      t.integer :img_id
      t.integer :is_dm
      t.integer :mt_root
      t.integer :user_id
      t.string :user_name

      t.timestamps
    end
  end
end
