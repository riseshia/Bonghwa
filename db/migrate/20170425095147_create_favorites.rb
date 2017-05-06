class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :firewood, foreign_key: true

      t.timestamps
    end
  end
end
