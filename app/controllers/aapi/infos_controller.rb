# frozen_string_literal: true

module Aapi
  # Aapi::InfosController
  class InfosController < Aapi::BaseController
    def index
      render json: { infos: data }
    end

    private

    def data
      Info.all.map(&:serialize)
    end
  end
end
