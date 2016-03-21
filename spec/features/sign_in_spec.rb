# frozen_string_literal: true
require "rails_helper"

RSpec.describe "SignIn", type: :feature do
  context "Not Logined" do
    before(:each) do
      create(:app)
      create(:user)
    end

    it "has redirect to session#new" do
      visit "/"
      expect(page).to have_content "Please sign in"
    end

    it "has fail to sign in" do
      visit "/"
      within("#login_form") do
        fill_in "login_id", with: "NotExist"
        fill_in "password", with: "NotExist"
      end
      click_button "Sign in"
      expect(page).to have_content "아이디/비밀번호가 올바르지 않습니다."
      expect(page).to have_content "Please sign in"
    end

    it "has success to sign in" do
      visit "/"
      within("#login_form") do
        fill_in "login_id", with: "user_id"
        fill_in "password", with: "userpwd"
      end
      click_button "Sign in"
      expect(page).to have_css("div#firewoods")
    end
  end
end
