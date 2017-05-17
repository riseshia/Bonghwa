# frozen_string_literal: true

module Api
  module Firewoods
    # Api::MentionsController
    class MentionsController < Api::BaseController
      include FirewoodsCommon

      def index
        render json: { fws: data }
      end

      private

      def data
        Firewood
          .includes(:favorites)
          .mts_of(params[:firewood_id], current_user.id, params[:target_id])
          .map { |fw| fw.serialize(current_user) }
      end
    end
  end
end
