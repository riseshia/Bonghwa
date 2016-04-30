# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Timeline", type: :feature, js: true do
  before(:each) do
    sign_in_via_browser :user
  end

  it "has no firewood" do
    visit "/"
    wait_for_ajax
    expect(find("#timeline").text).to be_empty
  end

  it "has 1 firewood" do
    visit "/"
    type "BlaBla"
    submit
    wait_for_ajax
    expect(page).to have_content("BlaBla")
  end
end
