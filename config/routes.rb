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

  resources :posts, path: '/', only: :show
end
