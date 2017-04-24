# frozen_string_literal: true

module Api
  module Firewoods
    # Api::PullingController
    class PullingController < Api::BaseController
      include FirewoodsCommon

      def index
        render json: {
          fws: fws_data(1000),
          user: {
            user_id: current_user.id,
            user_name: current_user.name
          }
        }
      end
    end
  end
end
