Morrwbah::Application.routes.draw do

  root :to => "feeds#index"
  
  get 'login', to: "sessions#new", as: "login"
  get 'logout', to: "sessions#destroy", as: "logout"
  resources :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create, :update, :destroy]

  resources :feeds do
    collection do
      get :fetch
    end
  end
  
  resources :entries, only: [:show, :update]

  resources :manage, only: :index

end
