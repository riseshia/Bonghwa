# frozen_string_literal: true

module Admin
  # AppController
  class AppController < Admin::BaseController
    def edit
    end

    def update
      @app = App.first

      if @app.update_attributes(app_params)
        redirect_to admin_app_edit_path,
                    notice: "app setting was successfully updated."
      else
        render :edit
      end
    end

    private

    def app_params
      params.require(:app).permit(:app_name, :home_link, :home_name,
                                  :show_widget, :use_script, :widget_link)
    end
  end
end
