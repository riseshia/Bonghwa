# frozen_string_literal: true

module Api
  module Firewoods
    # Api::NowController
    class NowController < Api::BaseController
      include FirewoodsCommon

      def index
        render json: { fws: fws_data(50) }
      end
    end
  end
end
