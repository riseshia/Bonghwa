# frozen_string_literal: true

require "test_helper"

module Api
  class FirewoodsControllerTest < ActionController::TestCase
    def setup
      sign_in_via_api user
    end

    def test_create_fw
      assert_difference "Firewood.count" do
        post :create, params: {
          firewood: { prev_mt: 0, contents: "firewoods" }
        }, format: :json
      end
      assert_response :ok
    end

    def test_create_with_root
      fw = firewoods(:good_morning_from_luna)

      assert_difference "Firewood.count" do
        post :create, params: {
          firewood: { contents: "firewoods", prev_mt: 0, root_mt_id: fw.id }
        }, format: :json
      end
      assert_response 200
    end

    def test_create_cmd
      assert_difference "Firewood.count", 2 do
        post :create, params: {
          firewood: { prev_mt: 0, contents: "/코인" }
        }, format: :json
      end

      assert_response 200
    end

    def test_create_dm
      assert_difference "Firewood.count" do
        post :create, params: {
          firewood: { prev_mt: 0, contents: "!#{user.name} dmdm" }
        }, format: :json
      end

      assert_response 200
    end

    def test_create_dm_without_content
      assert_difference "Firewood.count", 2 do
        post :create, params: {
          firewood: { prev_mt: 0, contents: "!#{user.name}" }
        }, format: :json
      end

      assert_response 200
    end

    def test_create_dm_without_content_but_with_image
      file = fixture_file_upload(
        Rails.root.join("test", "assets", "test.jpg"), "image/jpeg"
      )

      assert_difference "Firewood.count" do
        post :create, params: {
          firewood: { prev_mt: 0, contents: "!#{user.name}", image: file }
        }, format: :json
      end

      assert_response 200
      assert JSON.parse(response.body).blank?
    end

    def test_destroy_success
      fw = firewoods(:good_morning_from_asahi)

      assert_difference "Firewood.count", -1 do
        delete :destroy, params: { id: fw.id }, format: :json
      end

      assert_response 200
    end

    def test_destroy_fail
      fw = firewoods(:good_morning_from_luna)

      assert_no_difference "Firewood.count" do
        delete :destroy, params: { id: fw.id }, format: :json
      end

      assert_response 200
    end

    private

    def user
      @user ||= users(:asahi)
    end
  end
end
