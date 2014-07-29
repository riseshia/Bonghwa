class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :link_to
      t.string :name

      t.timestamps
    end
  end
end
