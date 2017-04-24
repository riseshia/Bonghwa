# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  controller :view do
    get "wait" => :wait
  end

  get :beta, to: redirect("/")
  root to:  "frontend#index"

  namespace :admin do
    resources :users, except: [:destroy, :new, :create] do
      put :lvup, on: :member
    end

    get :app, to: "app#edit"
    patch :app, to: "app#update"
  end

  namespace :api do
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
