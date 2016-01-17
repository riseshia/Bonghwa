require 'rails_helper'

RSpec.describe Attach, type: :model do
  describe 'Active Record Associations' do
    it { should have_one(:firewood) }
  end
end