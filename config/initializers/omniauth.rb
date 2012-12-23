Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, ENV["SDSZOMBI_TWITTER_KEY"], ENV["SDSZOMBI_TWITTER_SECRET"]
end