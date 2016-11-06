class RemoveLinks < ActiveRecord::Migration[5.0]
  def change
    drop_table :links
  end
end
