require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Active Record Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:login_id) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:login_id) }
  end

  describe 'Active Record Associations' do
    it { should have_many(:firewoods) }
  end
end
