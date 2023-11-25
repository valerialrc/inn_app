Rails.application.routes.draw do
  devise_for :customers
  devise_for :users
  root to: 'home#index'
  resources :users, only: [:new, :create]
  resources :inns, only: [:show, :new, :create, :edit, :update] do
    get 'search', on: :collection
    resources :rooms, except: [:destroy] do
      resources :period_prices, only: [:new, :create]
      resources :reservations, only: [:show, :new, :create] do
        get 'confirm_reservation', on: :collection
      end
    end
  end
  resources :reservations, only: [:index] do
    post 'canceled', on: :member
    post 'active', on: :member
  end
  resources :active_reservations, only: [:index] do
    post 'closed', on: :member
  end
  resources :closed_reservations, only: [:index]

  resources :cities, only: [:show]
end