Collos::Application.routes.draw do
  resources :users


  # resources :barcodes
  match "/barcode/generate(/:n)" => "barcode#generate", as: "barcode_generate"
  match "/barcode/fetch(/:sid)" =>  "barcode#fetch", as: "barcode_fetch"
  match "/barcode/" => "barcode#index",  as: "barcode"

  resources :ontologies
  resources :ontology_terms

  resources :taxons
  resources :taxon_names

  resources :protocols
  # resources :protocol_parameters
  resources :protocol_applications
  # resources :protocol_parameter_values

  resources :samples
  resources :sample_characteristics


  resources :containers
  resources :container_types



  root :to => "home#index"
  match "/about", to: "home#about", as: 'about', format: "html"
  match "/help", to: "home#help", as: 'help', format: "html"
  match "/contact", to: "home#contact", as: 'contact', format: "html"

  # omniauth
  match "/auth/:provider/callback" => "sessions#create"
  match "/login", to: "sessions#new", as: :login
  match "/logout", to: "sessions#destroy", as:  :logout
  match "/register", to: "identities#new", as: :register
  match "/auth/failure", to: "sessions#failure"

  resources :identities
end
