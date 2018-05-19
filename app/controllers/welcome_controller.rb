class WelcomeController < ApplicationController

  # GET /welcome
  def index

  end

  def setup
  	puts 'in setup'
  	puts session[:token]
  	puts session[:secret]
  	puts session[:twitter_username]

	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
	  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
	  config.access_token        = session[:token]
  	  config.access_token_secret = session[:secret]
	end


	client.follow('GilbertMelendez')
	redirect_to 'success'

  end

  def success

  end

end
