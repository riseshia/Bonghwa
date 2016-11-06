# frozen_string_literal: true
require "rails_helper"

module Admin
  RSpec.describe AppController, type: :controller do
    let!(:app) { create(:app) }
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    context "Not Logined" do
      it "has a redirction" do
        get :edit, params: { id: app.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "Not Admin" do
      it "has a redirction" do
        sign_in user
        get :edit, params: { id: app.id }
        expect(response).to redirect_to("/")
      end
    end

    context "Logined with Admin" do
      let(:valid_attributes) { { app_name: "New Name" } }

      before(:each) do
        sign_in admin
      end

      describe "#edit" do
        it "has a 200 status code" do
          get :edit, params: { id: app.id }
          expect(response.status).to eq(200)
        end
      end

      describe "#update" do
        it "will update app_name" do
          put :update, params: { id: app.id, app: valid_attributes }
          expect(response).to redirect_to(edit_admin_app_path(app))
          expect(App.first.app_name).to eq("New Name")
        end
      end
    end
  end
end
