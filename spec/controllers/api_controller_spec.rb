# frozen_string_literal: true
require "rails_helper"

RSpec.describe ApiController, type: :controller do
  context "Not Logined" do
    it "has a 302 status code" do
      create(:app)
      post :create, params: { firewood: attributes_for(:normal_message) }
      expect(response.status).to eq(302)
    end
  end

  context "Logined with normal User" do
    before(:example) do
      create(:app)
      sign_in create(:user)
    end

    describe "POST #create" do
      it "has a 200 status code" do
        post :create, params: { firewood: attributes_for(:normal_message) }
        expect(response.status).to eq(200)
      end

      it "create new firewood" do
        expect do
          post :create, params: { firewood: attributes_for(:normal_message) }
        end.to change(Firewood, :count).by(1)
      end
    end
  end
end
