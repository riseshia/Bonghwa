# frozen_string_literal: true

module Admin
  # AppController
  class AppController < Admin::BaseController
    def edit
      app = App.first
      render_edit(app)
    end

    def update
      app = App.first
      if app.update_attributes(app_params)
        redirect_to_app("app setting was successfully updated.")
      else
        render_edit(app)
      end
    end

    private

    def app_params
      params.require(:app).permit(:app_name, :home_link, :home_name,
                                  :show_widget, :use_script, :widget_link)
    end

    def render_edit(app)
      render :edit, locals: { app: app }
    end

    def redirect_to_app(message)
      redirect_to admin_app_path, notice: message
    end
  end
end
