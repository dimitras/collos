OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity, fields: [:email,:name], model: User, on_failed_registration:   UsersController.action(:register)
end
