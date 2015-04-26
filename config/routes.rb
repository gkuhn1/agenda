Rails.application.routes.draw do

  apipie

  namespace :admin do
    resources :dashboard, only: :index
    resources :accounts
    resources :users
  end

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do

      root :to => 'api#endpoint', :as => 'root'

      resources :accounts do
        collection do
          get :current
        end
      end
      resources :users do
        collection do
          get :current
          post :login
        end
      end
      resources :calendars, only: [:index, :show, :edit, :update] do
        resources :tasks
      end
      resources :specialties
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
