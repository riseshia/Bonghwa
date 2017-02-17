class AddDefaultValueToFirewood < ActiveRecord::Migration[5.0]
  def change
    change_column_default :firewoods, :is_dm, 0
    change_column_default :firewoods, :mt_root, 0
    change_column_default :firewoods, :prev_mt_id, 0
  end
end
