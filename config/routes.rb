require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'mangas#index'
  mount Sidekiq::Web, at: '/sidekiq'
  resources :mangas do
    collection do
      post '/view/:chapter_name', to: 'mangas#scrape_images', as: 'view'
    end
  end
  resources :chapters
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
