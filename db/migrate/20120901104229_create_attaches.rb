class CreateAttaches < ActiveRecord::Migration[4.2]
  def change
    create_table :attaches do |t|

      t.timestamps
    end
  end
end
