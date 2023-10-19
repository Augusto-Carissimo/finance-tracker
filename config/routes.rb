Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships
  get 'my_portfolio', to: 'users#my_portfolio'
  devise_for :users
  root "welcome#index"
  get 'search_stock', to: 'stocks#search'
  get 'search_friendships', to: 'friendships#search'
  resources :users, only: [:show]
end
