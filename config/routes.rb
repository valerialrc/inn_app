Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :users, only: [:new, :create]
  resources :inns, only: [:show, :new, :create, :edit, :update] do
    resources :addresses, only: [:new, :create, :edit, :update]
    resources :rooms, except: [:destroy] do
      resources :period_prices, only: [:new, :create]
    end
  end
  resources :cities, only: [:show]
end