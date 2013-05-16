OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :developer unless Rails.env.production?
    provider :identity, fields: [:email,:name], model: User, on_failed_registration:   UsersController.action(:register)
    provider :basecamp, ENV['BASECAMP_IDENTIFIER'], ENV['BASECAMP_SECRET']
end
