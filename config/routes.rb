Collos::Application.routes.draw do
  resources :taxon_names


  resources :taxons


  resources :protocol_applications


  resources :users


  # resources :barcodes
  match "/barcode/generate(/:n)" => "barcode#generate", as: "barcode_generate"
  match "/barcode/fetch(/:sid)" =>  "barcode#fetch", as: "barcode_fetch"
  match "/barcode/" => "barcode#index",  as: "barcode"


  # resources :protocol_parameter_values


  # resources :protocol_parameters


  resources :protocols


  resources :sample_characteristics


  resources :samples


  resources :containers


  resources :container_types


  resources :ontology_terms


  resources :ontologies


  root :to => "home#index"
  match "/about", to: "home#about", as: 'about', format: "html"
  match "/help", to: "home#help", as: 'help', format: "html"
  match "/contact", to: "home#contact", as: 'contact', format: "html"
end
