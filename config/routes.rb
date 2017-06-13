Rails.application.routes.draw do
  root to: 'posts#index'

  namespace :admin do
    get '/signin', to: 'sessions#new'
    post '/signin', to: 'sessions#create'
    delete '/signout', to: 'sessions#delete'

    resources :posts do
      post '/undestroy', on: :member, action: :undestroy
    end
  end

  get 'sitemap.xml', to: 'sitemaps#show', as: :sitemap, defaults: { format: :xml }

  resources :webmentions, only: %i[create show]

  resources :posts, path: '/', only: :show
end
