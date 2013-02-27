Collos::Application.routes.draw do
  root :to => "home#index"
  match "/about", to: "home#about", as: 'about', format: "html"
  match "/help", to: "home#help", as: 'help', format: "html"
  match "/contact", to: "home#contact", as: 'contact', format: "html"
end
