require 'rails_helper'

RSpec.describe Firewood, type: :model do
  describe 'Active Record Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:attach) }
  end

  describe '#normal?' do
    it 'should return true' do
      firewood = create(:normal_message)
      expect(firewood.normal?).to be(true)
    end
  end

  describe '#visible?' do
    it 'should return true' do
      user = create(:user2)
      firewood = create(:normal_message)
      expect(firewood.visible?(user.id)).to be(true)
    end

    it 'should return true when dm to user' do
      user = create(:user)
      create(:user2)
      firewood = create(:dm_message_to_user1)
      expect(firewood.visible?(user.id)).to be(true)
    end

    it 'should return true when dm user sent' do
      create(:user)
      user2 = create(:user2)
      firewood = create(:dm_message_to_user1)

      expect(firewood.visible?(user2.id)).to be(true)
    end

    it 'should return false when dm to the other user' do
      create(:user)
      create(:user2)
      user = create(:admin)
      firewood = create(:dm_message_to_user1)
      expect(firewood.visible?(user.id)).to be(false)
    end
  end

  describe '#to_hash_for_api' do
    it 'should return hash' do
      firewood = create(:normal_message)

      expect(firewood.to_hash_for_api).to eq('id' => firewood.id,
                                     'mt_root' => firewood.mt_root,
                                     'prev_mt' => firewood.prev_mt,
                                     'is_dm' => firewood.is_dm,
                                     'user_id' => firewood.user_id,
                                     'name' => firewood.user_name,
                                     'contents' => firewood.contents,
                                     'img_link' => firewood.img_link,
                                     'created_at' => firewood.created_at.strftime('%D %T'))
    end
  end

  describe 'Active Record Callbacks' do
    it 'should destroy related attach' do
      firewood = create(:normal_message)
      firewood.attach_id = create(:attach).id
      firewood.destroy

      expect(Attach.count).to be(0)
    end
  end

  describe '#img_link' do
    it 'should return 0' do
      firewood = create(:normal_message)
      expect(firewood.img_link).to eq('0')
    end

    it 'should return url' do
      firewood = create(:normal_message)
      attach = create(:attach)
      firewood.attach = attach
      expect(firewood.normal?).not_to eq('0')
    end
  end

  describe '#editable?' do
    it 'should return true' do
      firewood = create(:normal_message)
      user = create(:user)
      firewood.user_id = user.id
      firewood.save

      expect(firewood.editable?(user)).to be(true)
    end

    it 'should return false' do
      firewood = create(:normal_message)
      user = create(:user)

      expect(firewood.editable?(user)).to be(false)
    end
  end
end
