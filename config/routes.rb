Rails.application.routes.draw do
  root to: 'posts#index'

  namespace :admin do
    get '/signin', to: 'sessions#new'
    post '/signin', to: 'sessions#create'
    delete '/signout', to: 'sessions#delete'

    scope :api, controller: :api, defaults: { format: :json } do
      post '/update_location', action: :update_location
    end

    resources :articles do
      post '/undestroy', on: :member, action: :undestroy
    end

    resources :notes do
      post '/undestroy', on: :member, action: :undestroy
    end

    resources :media, only: %i[index new create destroy]
    resources :uploads, only: %i[index new create destroy]

    get '(*any)', to: 'admin#render404'
  end

  get 'sitemap.xml', to: 'sitemaps#show', as: :sitemap, defaults: { format: :xml }
  get 'feed', to: 'feeds#show', as: :feed, defaults: { format: :xml }
  post 'subscribe', to: 'subscribers#create'
  resources :webmentions, only: %i[create show]

  get '/now', to: 'pages#now'

  resources :posts, path: '/', only: :show

  [:article, :note, :like, :reply].each do |kind|
    direct kind do |post|
      post_url(post)
    end
  end
end
