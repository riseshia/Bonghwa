# frozen_string_literal: true
# AdminController
class AdminController < ApplicationController
  before_action :admin_check

  def edit
  end

  def update
    @app = App.first

    if @app.update_attributes(app_params)
      redirect_to admin_edit_url,
                  notice: "app setting was successfully updated."
    else
      render action: "edit"
    end
  end

  private

  def app_params
    params.require(:app).permit(:app_name, :home_link, :home_name,
                                :show_widget, :use_script, :widget_link)
  end
end
