Rails.application.routes.draw do
  root to: 'static_pages#root'

  namespace :api do
    resources :blogs do
      resources :posts, only: [:index]
    end
    resources :posts, except: [:index]
    resources :comments
  end

  resources :users
  resources :blogs do
    resources :posts do
      resources :comments
    end
  end
  resource :session
end
