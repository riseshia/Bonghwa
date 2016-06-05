# frozen_string_literal: true
require "rails_helper"

module Admin
  RSpec.describe AppController, type: :controller do
    context "Not Logined" do
      it "has a redirction" do
        create(:app)
        get :edit
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "Not Admin" do
      it "has a redirction" do
        create(:app)
        sign_in create(:user)
        get :edit
        expect(response).to redirect_to("/")
      end
    end

    context "Logined with Admin" do
      let(:valid_attributes) do
        { app_name: "New Name" }
      end

      before(:example) do
        create(:app)
        @user = create(:admin)
        sign_in @user
      end

      describe "#edit" do
        it "has a 200 status code" do
          get :edit
          expect(response.status).to eq(200)
        end
      end

      describe "#update" do
        it "will update app_name" do
          put :update, app: valid_attributes
          expect(response).to redirect_to(admin_app_edit_path)
          expect(App.first.app_name).to eq("New Name")
        end
      end
    end
  end
end
