require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  after(:example) do
    sign_out
  end

  context 'Not Logined' do
    it 'has a 302 status code' do
      post :new, firewood: attributes_for(:normal_message)
      expect(response.status).to eq(302)
    end
  end

  context 'Logined with normal User' do
    before(:example) do
      sign_in :user
    end

    after(:example) do
      $redis.zremrangebyrank("#{$servername}:fws", 0, 0)
    end

    describe 'POST #new' do
      it 'has a 200 status code' do
        post :new, firewood: attributes_for(:normal_message)
        expect(response.status).to eq(200)
      end

      it 'create new firewood' do
        expect do
          post :new, firewood: attributes_for(:normal_message)
        end.to change(Firewood, :count).by(1)

        expect($redis.zrevrange("#{$servername}:fws", 0, 500).size).to eq(1)
      end
    end
  end
end