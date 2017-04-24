# frozen_string_literal: true

module Api
  # Api::InfosController
  class InfosController < Api::BaseController
    def index
      render json: { infos: data }
    end

    private

    def data
      Info.all.map(&:serialize)
    end
  end
end
