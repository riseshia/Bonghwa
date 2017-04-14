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
  get "beta", to: "frontend#index"

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

  root to:  "view#timeline"
  get :app, to: redirect("app.html")

  namespace :admin do
    resources :users, except: [:destroy, :new, :create] do
      put :lvup, on: :member
    end

    get :app, to: "app#edit"
    patch :app, to: "app#update"
  end

  namespace :api do
    post :new, to: "entry#create_dm", constraints: DmConstraint.new
    post :new, to: "entry#create_cmd", constraints: CmdConstraint.new
    post :new, to: "entry#create"
    delete :destroy, to: "entry#destroy"

    get :now, to: "entry#now"
    get :trace, to: "entry#trace"
    get :get_mt, to: "entry#mts"
    get :pulling, to: "entry#pulling"
  end

  namespace :aapi do
    resource :session, only: %i(create destroy), controller: :session
    resources :infos, only: %i(index)
    resources :users, only: %i(index)
    resource :app, only: %i(show), controller: :app
    resources :firewoods, only: %i(create destroy) do
      resources :mentions, only: %i(index), controller: "firewoods/mentions"
    end
    namespace :firewoods do
      resources :now, only: %i(index), controller: :now
      resources :trace, only: %i(index), controller: :trace
      resources :pulling, only: %i(index), controller: :pulling
    end
  end

  resources :users, only: [:show, :edit, :update]
end
