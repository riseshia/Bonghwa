require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Active Record Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:login_id) }
  end

  describe 'Active Record Associations' do
    it { should have_many(:firewoods) }
  end

  describe '#admin?' do
    it 'should return false' do
      expect(create(:user).admin?).to be(false)
    end

    it 'should return true' do
      expect(create(:admin).admin?).to be(true)
    end
  end
end
