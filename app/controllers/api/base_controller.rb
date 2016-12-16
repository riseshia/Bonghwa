# frozen_string_literal: true
# Api::BaseController
module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
  end
end
