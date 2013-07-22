OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    # This one seems to be a bit flaky. May have to change it.
    provider "37signals", CONFIG.application.basecamp_client_id,
        CONFIG.application.basecamp_secret
end

