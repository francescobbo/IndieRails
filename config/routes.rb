Rails.application.routes.draw do
  root to: 'posts#index'

  namespace :admin do
    get '/signin', to: 'sessions#new'
    post '/signin', to: 'sessions#create'
    delete '/signout', to: 'sessions#delete'

    resources :posts do
      post '/undestroy', on: :member, action: :undestroy
    end

    resources :media, only: [:index, :new, :create, :destroy]
  end

  get 'sitemap.xml', to: 'sitemaps#show', as: :sitemap, defaults: { format: :xml }

  get :micropub, to: 'micropub#discovery', as: :micropub
  post :micropub, to: 'micropub#actions'

  resources :webmentions, only: %i[create show]

  resources :posts, path: '/', only: :show
end
