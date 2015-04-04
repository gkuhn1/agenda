Rails.application.routes.draw do

  devise_for :users, path: 'accounts', :controllers => {:registrations => "registrations"}, path_names: { sign_up: "registrar", sign_in: "entrar" }

  namespace :admin do
    resources :homepages, only: :index
    resources :user_accounts
    resources :accounts
    resources :users
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :accounts, only: :current do
        collection do
          get :current
        end
      end
      resources :users, only: :current do
        collection do
          get :current
        end
      end
    end
  end

  resources :homepages do
    collection do
      get :select_account
    end
    member do
      get :select_account
    end
  end

  root to: "homepages#index"

end
