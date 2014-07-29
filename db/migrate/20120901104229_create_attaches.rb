class CreateAttaches < ActiveRecord::Migration
  def change
    create_table :attaches do |t|

      t.timestamps
    end
  end
end
