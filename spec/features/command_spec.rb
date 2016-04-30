# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Command", type: :feature, js: true do
  before(:each) do
    sign_in_via_browser :admin
  end

  context "Command Usage Scenario" do
    it "Info" do
      visit "/"
      type "/공지추가 테스트공지"
      submit
      wait_for_ajax
      expect(page).to have_content("공지가 등록되었습니다.")
      expect(Info.all_with_cache.count).to eq(1)
      expect(Info.count).to eq(1)

      visit "/"
      expect(find("#info")).to have_content("테스트공지")

      type "/공지삭제 1"
      submit
      wait_for_ajax
      expect(page).to have_content("삭제 완료되었습니다.")
      expect(Info.all_with_cache.count).to eq(0)
      expect(Info.count).to eq(0)
    end
  end
end
