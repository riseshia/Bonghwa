# frozen_string_literal: true

module Api
  # Api::FavoritesController
  class FavoritesController < Api::BaseController
    def create
      fw = Firewood.find_by(id: passed_fw_id)

      if fw&.visible?(current_user.id)
        Favorite.find_or_create_by!(
          firewood_id: passed_fw_id,
          user_id: current_user.id
        )
        render json: { status: :success }, status: :created
      else
        render json: { status: :fail }, status: :ok
      end
    end

    def destroy
      fav = Favorite.find_by(
        firewood_id: params[:firewood_id],
        user_id: current_user.id
      )

      result = \
        if fav&.user_id == current_user.id
          fav.destroy!
          :success
        else
          :fail
        end
      render json: { status: result }, status: :ok
    end

    private

    def passed_fw_id
      @_passed_fw_id ||= params[:firewood_id]
    end
  end
end
