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
end
