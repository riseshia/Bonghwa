class RemoveTagsFromFirewood < ActiveRecord::Migration[4.2]
  def up
    add_column :attaches, :adult_flg, :boolean, default: false, null: false

    Firewood.where.not(attach_id: 0).find_each do |firewood|
      attach = firewood.attach
      adult_tag = " <span class='has-image text-warning'>" \
                  "[후방주의 #{attach.id}]</span>"
      normal_tag = " <span class='has-image'>[이미지 #{attach.id}]</span>"
      if firewood.contents.end_with?(adult_tag)
        firewood.contents.gsub!(adult_tag, "")
        firewood.save
        attach.toggle!(:adult_flg)
      elsif firewood.contents.end_with?(normal_tag)
        firewood.contents.gsub!(normal_tag, "")
        firewood.save
      end
    end
  end

  def down
    remove_column :attaches, :adult_flg, :boolean, default: false, null: false
  end    
end
