# frozen_string_literal: true

module Api
  module Firewoods
    # Api::TraceController
    class TraceController < Api::BaseController
      include FirewoodsCommon

      def index
        limit = params[:limit].to_i.clamp(0, 50) # Limit maximum size
        render json: { fws: fws_data(limit) }
      end
    end
  end
end
