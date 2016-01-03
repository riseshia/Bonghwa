# App
class App < ActiveRecord::Base
  attr_accessible :app_name, :home_link, :home_name, :show_widget, :use_script, :widget_link
end
