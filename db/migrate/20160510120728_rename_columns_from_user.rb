class RenameColumnsFromUser < ActiveRecord::Migration
  def change
    rename_column :users, :password_digest, :legacy_password
  end
end
