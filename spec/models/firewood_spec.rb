require 'rails_helper'

RSpec.describe Firewood, type: :model do
  describe 'Active Record Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:attach) }
  end
end
