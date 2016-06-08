# frozen_string_literal: true

module Admin
  # LinksController
  class LinksController < ApplicationController
    before_action :set_link, only: [:edit, :update, :destroy]

    # GET /links
    # GET /links.json
    def index
      @links = Link.all_with_cache
    end

    # GET /links/new
    # GET /links/new.json
    def new
      @link = Link.new
    end

    # GET /links/1/edit
    def edit
    end

    # POST /links
    # POST /links.json
    def create
      @link = Link.new(link_params)

      if @link.save
        redirect_to admin_links_url, notice: "Link was successfully created."
      else
        render action: "new"
      end
    end

    # PUT /links/1
    # PUT /links/1.json
    def update
      if @link.update_attributes(link_params)
        redirect_to admin_links_url, notice: "Link was successfully updated."
      else
        render action: "edit"
      end
    end

    # DELETE /links/1
    # DELETE /links/1.json
    def destroy
      @link.destroy
      redirect_to links_url
    end

    private

    def link_params
      params.require(:link).permit(:link_to, :name)
    end

    def set_link
      @link = Link.find(params[:id])
    end
  end
end
