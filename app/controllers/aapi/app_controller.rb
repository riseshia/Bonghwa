# frozen_string_literal: true

module Aapi
  # Aapi::AppController
  class AppController < Aapi::BaseController
    def show
      current_user.update_login_info(Time.zone.now.to_i)

      render json: {
        users: users_data,
        infos: infos_data,
        fws: fws_data,
        app: app_data
      }
    end

    private

    def app_data
      App.first_with_cache
    end

    def users_data
      User.on_timeline(Time.zone.now.to_i)
    end

    def infos_data
      Info.all.map(&:serialize)
    end

    def fws_data
      Firewood.trace(current_user, 50).map(&:serialize)
    end
  end
end
