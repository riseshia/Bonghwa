class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :login_id
      t.string :password_digest
      t.string :name
      t.integer :level, default: 0
      t.datetime :recent_login

      t.timestamps
    end
  end
end
