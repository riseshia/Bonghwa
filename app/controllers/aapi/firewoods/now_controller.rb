# frozen_string_literal: true

module Aapi
  module Firewoods
    # Aapi::NowController
    class NowController < Aapi::BaseController
      include FirewoodsCommon

      def index
        render json: { fws: fws_data(50) }
      end
    end
  end
end
