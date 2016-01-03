require 'rails_helper'

describe User, type: :model do
  it 'will be created successfully' do
    create(:user)
  end

  it "won't be created when user don't type login_id" do
    user = build(:user)
    user.login_id = nil
    user.save

    expect(user.id).to eq(nil)
  end
end
