Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :users, only: [:new, :create]
  resources :inns, only: [:show, :new, :create, :edit, :update] do
    get 'search', on: :collection
    resources :addresses, only: [:new, :create, :edit, :update]
    resources :rooms, except: [:destroy] do
      resources :period_prices, only: [:new, :create]
      resources :reservations, only: [:show, :new, :create] do
        get 'confirm_reservation', on: :collection
      end
    end
  end
  resources :cities, only: [:show]
end