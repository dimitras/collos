OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    unless Rails.env.production?
        provider :developer, fields: [:email,:name]
    end
    # This one seems to be a bit flaky. May have to change it.
    provider "37signals", ENV['BASECAMP_CLIENT_ID'], ENV['BASECAMP_SECRET']
end

