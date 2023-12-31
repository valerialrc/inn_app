Rails.application.routes.draw do
  devise_for :customers
  devise_for :users
  root to: 'home#index'
  resources :users, only: [:new, :create]
  resources :inns, only: [:show, :new, :create, :edit, :update] do
    resources :reviews, only: [:index]
    get 'search', on: :collection
    resources :rooms, except: [:destroy] do
      resources :period_prices, only: [:new, :create]
      resources :reservations, only: [:show, :new, :create] do
        get 'confirm_reservation', on: :collection
      end
    end
  end
  resources :reservations, only: [:index, :show] do
    resources :consumed_items, only: [:new, :create]
    resources :reviews, only: [:new, :create]
    post 'canceled', on: :member
    post 'active', on: :member
  end

  resources :reviews, only: [:index] do
    resources :answers, only: [:new, :create]
  end
  resources :active_reservations, only: [:index] do
    post 'closed', on: :member
  end
  resources :closed_reservations, only: [:index]

  resources :cities, only: [:show]

  namespace :api do 
    namespace :v1 do
      resources :inns, only: [:show, :index, :create] do
        resources :rooms, only: [:index, :show] do
          get 'check_availability', on: :member
        end
      end
      resources :cities, only: [:index, :show]
    end
  end
end