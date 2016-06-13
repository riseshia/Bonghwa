# frozen_string_literal: true
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

    get "app/edit", controller: :app, action: :edit
    put "app/update", controller: :app, action: :update

    resources :links, except: [:show]
  end

  controller :api do
    post "api/new" => :create
    delete "api/destroy" => :destroy

    get "api/now" => :now
    get "api/trace" => :trace

    get "api/get_mt" => :get_mt

    get "api/pulling" => :pulling
  end

  resources :users, only: [:show, :edit, :update]
end
