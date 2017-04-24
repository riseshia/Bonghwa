# frozen_string_literal: true

require "test_helper"

module Api
  module Firewoods
    class PullingControllerTest < ActionController::TestCase
      def setup
        sign_in_via_api users(:asahi)
      end

      %w[1 2 3].each do |t|
        define_method "test_index_with_type_#{t}" do
          get :index, params: { type: t }, format: :json

          assert_response :ok
          assert_response_json_has_keys %w[fws user]
        end
      end
    end
  end
end
