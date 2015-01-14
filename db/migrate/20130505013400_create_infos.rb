class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :infomation

      t.timestamps
    end
  end
end
