Rails.application.routes.draw do

  devise_for :users

  namespace :admin do
    resources :homepages, only: :index
    resources :user_accounts
    resources :accounts
    resources :users
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :accounts do
        collection do
          get :current
        end
      end
      resources :users do
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
