# frozen_string_literal: true
require "rails_helper"

module Admin
  RSpec.describe UsersController, type: :controller do
    context "Not Logined" do
      it "has a redirction" do
        create(:app)
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "Not Admin" do
      it "has a redirction" do
        create(:app)
        sign_in create(:user)
        get :index
        expect(response).to redirect_to("/")
      end
    end

    context "Logined with Admin" do
      before(:example) do
        create(:app)
        @user = create(:admin)
        sign_in @user
      end

      describe "#index" do
        render_views

        it "has a 200 status code" do
          create(:unconfirmed_user)
          get :index
          expect(response.status).to eq(200)
        end
      end

      describe "#lvup" do
        it "will update level to 1 of user" do
          user = create(:unconfirmed_user)
          put :lvup, id: user.to_param
          expect(user.reload.level).to eq(1)
          expect(response).to redirect_to(admin_users_path)
        end

        it "will no effect with admin level" do
          put :lvup, id: @user.to_param
          expect(@user.reload.level).to eq(999)
          expect(response).to redirect_to(admin_users_path)
        end
      end
    end
  end
end
