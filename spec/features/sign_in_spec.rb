# frozen_string_literal: true
require "rails_helper"

RSpec.describe "SignIn", type: :feature do
  context "Not Logined" do
    it 'has redirect to session#new' do
      create(:app)
      visit "/"
      expect(page).to have_content "Please sign in"
    end
  end
end
