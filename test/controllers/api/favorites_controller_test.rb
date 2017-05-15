# frozen_string_literal: true

require "test_helper"

module Api
  class FavoritesControllerTest < ActionController::TestCase
    def setup
      @user = users(:asahi)
      @fw = firewoods(:good_evening_from_luna)

      sign_in_via_api users(:asahi)
    end

    def test_create_favorite_success_from_normal_fw
      assert_difference "Favorite.count" do
        post :create, params: { firewood_id: @fw.id }, format: :json
        assert_response :created
      end
    end

    def test_create_favorite_success_from_dm
      luna = users(:luna)
      fw = dm(luna, @user, "紅茶を淹れてくれ")

      assert_difference "Favorite.count" do
        post :create, params: { firewood_id: fw.id }, format: :json
        assert_response :created
      end
    end

    def test_create_dubplicated_favorite_success
      Favorite.create(firewood_id: @fw.id, user_id: @user.id)

      assert_no_difference "Favorite.count" do
        post :create, params: { firewood_id: @fw.id }, format: :json
        assert_response :created
      end
    end

    def test_fails_to_create_favorite_to_invisible_fw
      luna = users(:luna)
      gnunu = users(:gnunu)
      fw = dm luna, gnunu, "だが、断る"

      assert_no_difference "Favorite.count" do
        post :create, params: { firewood_id: fw.id }, format: :json
        assert_response :ok
      end
    end

    def test_fails_to_create_with_not_exist_firewood
      assert_no_difference "Favorite.count" do
        post :create, params: { firewood_id: 0 }, format: :json
        assert_response :ok
      end
    end

    def test_destroy_favorite
      Favorite.create(firewood_id: @fw.id, user_id: @user.id)

      assert_difference "Favorite.count", -1 do
        delete :destroy, params: { firewood_id: @fw.id }, format: :json
        assert_response :ok
      end
    end

    def test_fails_to_destroy_favorite
      luna = users(:luna)
      Favorite.create(firewood_id: @fw.id, user_id: luna.id)

      assert_no_difference "Favorite.count"  do
        delete :destroy, params: { firewood_id: @fw.id }, format: :json
        assert_response :ok
      end
    end

    def test_fails_to_destroy_with_not_exist_favorite
      assert_no_difference "Favorite.count"  do
        delete :destroy, params: { firewood_id: 0 }, format: :json
        assert_response :ok
      end
    end
  end
end
