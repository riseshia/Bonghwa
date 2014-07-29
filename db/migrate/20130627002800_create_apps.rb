class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :home_name
      t.string :home_link
      t.string :app_name
      t.integer :use_script
      t.integer :show_widget
      t.string :widget_link

      t.timestamps
    end
  end
end
