# frozen_string_literal: true

module Aapi
  # Aapi::UsersController
  class UsersController < Aapi::BaseController
    def index
      render json: { users: data }
    end

    def data
      User.on_timeline(Time.zone.now.to_i)
    end
  end
end
