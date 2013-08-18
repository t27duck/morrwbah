Morrwbah::Application.routes.draw do

  root :to => 'dashboard#index'
  
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resources :sessions, only: [:new, :create, :destroy]

  resources :users

  get "dashboard/entries/:id" => "dashboard#entries", as: "dashboard_entries"
  resources :dashboard, :only => :index do
    collection do
      get :settings
      get :feeds
    end
  end

  resources :feeds do
    member do
      get :fetch
    end
  end
  
  resources :entries, :only => [:index, :show, :update]

end
