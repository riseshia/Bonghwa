# frozen_string_literal: true

module Users
  # SessionsController
  class SessionsController < Devise::SessionsController
    skip_before_action :block_unconfirmed
    skip_before_action :set_current_user
    before_action :configure_sign_in_params, only: :create

    layout "users"

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      super
      current_user.update(recent_login: Time.zone.now)
      current_user.generate_token.reload
      cookies[:token] = current_user.authentication_token
    end

    # DELETE /resource/sign_out
    def destroy
      current_user.clear_token
      super
    end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:login_id])
    end
  end
end
