# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Timeline", type: :feature do
  before(:each) do
    sign_in_via_browser :user
  end

  it "has no firewood" do
    visit "/"
    # wait_for_ajax
    expect(page).to have_content("준비중...")
  end

  it "has 1 firewood" do
    message = create(:normal_message)
    visit "/"
    wait_for_ajax
    expect(page).to have_content(message.contents)
  end
end
