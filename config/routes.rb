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

      resources :notifications, only: [:index] do
        member do
          put :mark_as_read
          put :mark_as_unread
        end
      end
    end
  end

  root to: "homepages#index"

end
