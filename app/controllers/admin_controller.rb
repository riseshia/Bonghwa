# frozen_string_literal: true
# AdminController
class AdminController < ApplicationController
  before_action :admin_check

  def edit
  end

  def update
    @app = App.first

    respond_to do |format|
      if @app.update_attributes(app_params)
        format.html { redirect_to admin_edit_url, notice: "app setting was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def app_params
    params.require(:app).permit(:app_name, :home_link, :home_name, :show_widget, :use_script, :widget_link)
  end
end
