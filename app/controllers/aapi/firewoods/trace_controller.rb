# frozen_string_literal: true

module Aapi
  module Firewoods
    # Aapi::TraceController
    class TraceController < Aapi::BaseController
      include FirewoodsCommon

      def index
        limit = params[:count].to_i.clamp(0, 50) # Limit maximum size
        render json: { fws: fws_data(limit) }
      end
    end
  end
end
