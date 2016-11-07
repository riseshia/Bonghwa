# frozen_string_literal: true
class CmdConstraint
  def matches?(request)
    request.request_parameters["firewood"]["contents"].match("^/.+").present?
  end
end

class DmConstraint
  def matches?(request)
    request.request_parameters["firewood"]["contents"].match("^!.+").present?
  end
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  controller :view do
    get "timeline" => :timeline
    get "option" => :option
    get "help" => :help
    get "wait" => :wait
  end
  root to:  "view#timeline", as: "index"

  namespace :admin do
    resources :users, except: [:destroy, :new, :create] do
      put :lvup, on: :member
    end

    resources :app, only: [:edit, :update]
  end

  controller :api do
    post "api/new" => :create_dm, constraints: DmConstraint.new
    post "api/new" => :create_cmd, constraints: CmdConstraint.new
    post "api/new" => :create
    delete "api/destroy" => :destroy

    get "api/now" => :now
    get "api/trace" => :trace
    get "api/get_mt" => :mts
    get "api/pulling" => :pulling
  end

  resources :users, only: [:show, :edit, :update]
end
