OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    unless Rails.env.production?
        provider :developer, fields: [:email,:name]
    end

    provider :identity, fields: [:email,:name],
        on_failed_registration: lambda {|env|
            IdentitiesController.action(:new).call(env)
        }

    provider :basecamp, ENV['BASECAMP_CLIENT_ID'], ENV['BASECAMP_SECRET']

end
