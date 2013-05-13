Collos::Application.routes.draw do
  resources :shipments


  resources :users do
    member do
      post 'activate'
      post 'inactivate'
    end
  end
  resources :contacts
  resources :addresses

  resources :barcodes, except: :destroy do
    collection do
      post 'generate'
      get  'fetch'
    end
  end

  resources :ontologies
  resources :ontology_terms

  resources :taxons
  resources :taxon_names

  resources :protocols
  # resources :protocol_parameters
  resources :protocol_applications
  # resources :protocol_parameter_values

  resources :samples do
    collection do
      post 'annotate'
      post 'query'
      post 'upload'
    end
  end

  resources :sample_characteristics


  resources :containers
  resources :container_types


  # static content pages
  match "/help", to: "pages#help", as: 'help', format: "html"
  match "/about", to: "pages#about", as: 'about', format: "html"
  match "/contact", to: "pages#contact", as: 'contact', format: "html"

  # omniauth
  match "/auth/:provider/callback" => "sessions#create"
  match "/login", to: "sessions#new", as: :login
  match "/logout", to: "sessions#destroy", as:  :logout
  match "/register", to: "identities#new", as: :register
  match "/auth/failure", to: "sessions#failure"

  root :to => "pages#index"

end
