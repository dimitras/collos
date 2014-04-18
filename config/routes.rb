require 'sidekiq/web'
require 'api_constraints'

Collos::Application.routes.draw do

  resources :material_types do
    collection do
      get 'search'
    end
  end

  resources :people do
    collection do
      get 'search'
    end
  end

  resources :investigations do
    collection do
      get 'search'
    end
  end

  resources :studies do
    collection do
      get 'search'
    end
  end

  resources :shipments do
    collection do
      get 'search'
    end
    member do
      post 'receive'
      post 'ship'
    end
  end

  resources :users do
    member do
      post 'activate'
      post 'deactivate'
    end
  end

  resources :addresses do 
    member do 
      post 'assign'
      post 'remove'
    end
  end

  resources :barcodes, except: :destroy do
    collection do
      post 'generate'
      get  'fetch'
    end
  end

  resources :ontologies
  resources :ontology_terms do
    collection do
      get 'query'
    end
  end

  resources :taxons do
    collection do
      get 'search'
    end
  end

  resources :protocols
  # resources :protocol_parameters
  resources :protocol_applications
  # resources :protocol_parameter_values

  resources :samples do
    collection do
      get 'search'
      post 'upload'
      post :edit_multiple
      put :update_multiple
      put :create_multiple
      # match 'containers/update_laboratory_select/:id', :controller=>'containers', :action => 'update_laboratory_select'
      # match 'containers/update_freezer_select/:id', :controller=>'containers', :action => 'update_freezer_select'
      # match 'containers/update_box_select/:id', :controller=>'containers', :action => 'update_box_select'
      # match 'containers/update_tube_select/:id', :controller=>'containers', :action => 'update_tube_select'
    end
    member do
      post 'place' # place this object into a container
    end
  end

  resources :containers do
    collection do
      get 'search'
      get 'collect_objects'
      post 'place_objects'
      post :edit_multiple
      put :update_multiple
    end
    member do
      post 'place' # place this object into a container
    end
  end

  resources :container_types

  # static content pages
  match "/help", to: "pages#help", as: 'help', format: "html"
  match "/about", to: "pages#about", as: 'about', format: "html"
  match "/contact", to: "pages#contact", as: 'contact', format: "html"

  # omniauth
  match "/auth/:provider/callback" => "sessions#create"
  match "/login", to: "sessions#new", as: :login
  match "/logout", to: "sessions#destroy", as:  :logout
  # match "/register", to: "identities#new", as: :register
  match "/auth/failure", to: "sessions#failure", as: :login_failure

  # search page
  match "/search", to: "search#index", as: :search

  # Sidekiq background work processor
  require "sidekiq_auth"
  mount Sidekiq::Web, at: '/sidekiq', constraints: SidekiqAuth.new

  # Any path that is not found get re-directed to the root path
  # match ':not_found' => redirect(), :constraints => { :not_found => /.*/ }
  root :to => "pages#index"

end
