# frozen_string_literal: true

module Api
  # Api::AppController
  class AppController < Api::BaseController
    include FirewoodsCommon

    def show
      current_user.update_login_info(Time.zone.now.to_i)

      render json: {
        users: users_data,
        infos: infos_data,
        fws: fws_data(50),
        app: app_data,
        user: user_data
      }
    end

    private

    def app_data
      app = App.first_with_cache
      {
        home_name: app.home_name,
        home_link: app.home_link,
        app_name: app.app_name,
        widget_link: app.widget_link
      }
    end

    def user_data
      {
        user_id: current_user.id,
        user_name: current_user.name
      }
    end

    def users_data
      User.on_timeline(Time.zone.now.to_i)
    end

    def infos_data
      Info.all.map(&:serialize)
    end
  end
end
