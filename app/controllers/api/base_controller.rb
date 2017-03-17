# frozen_string_literal: true
module Api
  # Api::BaseController
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
  end
end
