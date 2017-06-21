Rails.application.routes.draw do
  root to: 'posts#index'

  namespace :admin do
    get '/signin', to: 'sessions#new'
    post '/signin', to: 'sessions#create'
    delete '/signout', to: 'sessions#delete'

    resources :articles do
      post '/undestroy', on: :member, action: :undestroy
    end

    resources :media, only: %i[index new create destroy]

    get '(*any)', to: 'admin#render404'
  end

  direct :admin_posts do
    [:admin, :articles]
  end

  direct :admin_post do |post|
    admin_article_url(post)
  end

  get 'sitemap.xml', to: 'sitemaps#show', as: :sitemap, defaults: { format: :xml }
  get 'feed', to: 'feeds#show', as: :feed, defaults: { format: :xml }

  resources :webmentions, only: %i[create show]

  resources :posts, path: '/', only: :show
end
