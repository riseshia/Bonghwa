# frozen_string_literal: true

module Aapi
  # Aapi::SessionController
  class SessionController < Aapi::BaseController
    skip_before_action :authenticate_user_from_token!, only: :create

    def create
      info = permitted_params
      user = User.find_by(login_id: info[:login_id])
      if user&.valid_password?(info[:password])
        user.generate_token.reload
        render json: {
          status: "success",
          token: user.authentication_token
        }
      else
        render json: {
          status: "fail",
          message: "fail to create session"
        }
      end
    end

    def destroy
      current_user.clear_token
      sign_out current_user
      render json: {
        status: "success",
        message: "good bye"
      }
    end

    private

    def permitted_params
      params.permit(:login_id, :password)
    end
  end
end
