Rails.application.routes.draw do
  controller :view do
    get 'timeline' => :timeline
    get 'option' => :option
    get 'help' => :help
  end

  controller :admin do
    get 'admin/edit' => :edit
    put 'admin/update' => :update
  end

  controller :api do
    post 'api/new' => :new
    delete 'api/destroy' => :destroy

    get 'api/now' => :now
    get 'api/trace' => :trace

    get 'api/get_mt' => :get_mt

    get 'api/pulling' => :pulling
  end

  controller :bonghwa do
    get "bonghwa" => :index
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :links, except: [:show]

  resources :users do
    get :lvup, on: :collection
  end

  root to:  'view#timeline', as: 'index'
end
