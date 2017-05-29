class RenameColumnsFromUser < ActiveRecord::Migration[4.2]
  def change
    rename_column :users, :password_digest, :legacy_password
  end
end
