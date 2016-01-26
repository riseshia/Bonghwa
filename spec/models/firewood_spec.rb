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

  describe '#to_json' do
    it 'should return hash' do
      firewood = create(:normal_message)

      expect(firewood.to_json).to eq({
        'id' => firewood.id,
        'mt_root' => firewood.mt_root,
        'prev_mt' => firewood.prev_mt,
        'is_dm' => firewood.is_dm,
        'user_id' => firewood.user_id,
        'name' => firewood.user_name,
        'contents' => firewood.contents,
        'img_link' => firewood.img_link,
        'created_at' => firewood.created_at.strftime('%D %T')
      })
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
end
