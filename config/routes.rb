Rails.application.routes.draw do
  get 'my_portofolio', to: 'users#my_portofolio'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"
end
