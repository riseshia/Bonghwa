# frozen_string_literal: true

module Admin
  # BaseController
  class BaseController < ApplicationController
    before_action :admin_check
    protect_from_forgery with: :exception
  end
end
