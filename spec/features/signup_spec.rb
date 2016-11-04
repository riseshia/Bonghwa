# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Signup", type: :feature, js: true do
  before(:each) do
    no_sign_in_via_browser
  end

  it "sign up to service" do
    visit "/"
    expect(find(".form-signin-heading").text).to eq("로그인해주세요.")

    click_on "or Sign up"
    expect(find("h2").text).to eq("Sign up")
  end
end
