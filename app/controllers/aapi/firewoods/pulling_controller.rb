# frozen_string_literal: true

module Aapi
  module Firewoods
    # Aapi::PullingController
    class PullingController < Aapi::BaseController
      include FirewoodsCommon

      def index
        render json: { fws: fws_data(1000) }
      end
    end
  end
end
