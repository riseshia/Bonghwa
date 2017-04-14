# frozen_string_literal: true

module Aapi
  module Firewoods
    # Aapi::PullingController
    class PullingController < Aapi::BaseController
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
