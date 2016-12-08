# frozen_string_literal: true

module Admin
  # BaseController
  class BaseController < ApplicationController
    before_action :admin_check
    protect_from_forgery with: :exception

    private

    def admin_check
      unless @user.admin?
        redirect_to root_path,
                    notice: "접근 권한이 없습니다. 관리자에게 문의해주세요."
      end 
    end
  end
end
