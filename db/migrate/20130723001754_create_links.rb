class CreateLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :links do |t|
      t.string :link_to
      t.string :name

      t.timestamps
    end
  end
end
