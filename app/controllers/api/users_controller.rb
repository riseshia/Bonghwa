# frozen_string_literal: true

module Api
  # Api::UsersController
  class UsersController < Api::BaseController
    def index
      render json: { users: data }
    end

    def data
      User.on_timeline(Time.zone.now.to_i)
    end
  end
end
