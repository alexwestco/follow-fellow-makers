Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY'), ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
end