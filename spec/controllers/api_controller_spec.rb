require 'rails_helper'


RSpec.describe ApiController, type: :controller do
  after(:example) do
    sign_out
  end

  context 'Not Logined' do
    it 'has a 302 status code' do
      post :new, { firewood: attributes_for(:normal_message) }
      expect(response.status).to eq(302)
    end
  end

  context 'Logined with normal User' do
    describe 'POST #new' do
      it 'has a 200 status code' do
        sign_in :user
        post :new, { firewood: attributes_for(:normal_message) }
        expect(response.status).to eq(200)
      end
    end
  end
end