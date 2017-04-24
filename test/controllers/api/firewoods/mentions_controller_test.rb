# frozen_string_literal: true

require "test_helper"

module Api
  module Firewoods
    class MentionsControllerTest < ActionController::TestCase
      def setup
        sign_in_via_api users(:asahi)
      end

      def test_index
        fw = firewoods(:good_evening_from_luna)
        target = firewoods(:reply_from_luna)
        get :index, params: { firewood_id: fw.id, target_id: target.id },
                    format: :json

        assert_response :ok
        assert_equal 2, JSON.parse(response.body)["fws"].size
      end
    end
  end
end
