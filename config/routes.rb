Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # mailer
  get '/mailer', to: 'mail#new'
  post '/mailer', to: 'mail#sendmail'

  # Render email id form
  get '/recover', to: 'users#getRecover'
  post '/recover', to: 'users#postRecover'

  get '/reset', to: 'users#getReset'
  post '/reset', to: 'users#postReset'

  get '/invites/all', to: 'invites#getall'
  get '/invites/bulk', to: 'invites#getBulk'
  post '/invites/bulk', to: 'invites#postBulk'
  resources :users

  # Invites
  resources :invites

  # clients
  get '/clients/bulk', to: 'clients#getBulk'
  post '/clients/bulk', to: 'clients#postBulk'
  resources :clients
end
