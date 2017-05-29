class CreateInfos < ActiveRecord::Migration[4.2]
  def change
    create_table :infos do |t|
      t.string :infomation

      t.timestamps
    end
  end
end
