class RenameImageAdultFlgToSensitiveFlgOnFirewood < ActiveRecord::Migration[5.0]
  def change
    rename_column :firewoods, :image_adult_flg, :sensitive_flg
  end
end
