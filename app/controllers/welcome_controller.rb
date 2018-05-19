require "net/http"

class WelcomeController < ApplicationController

  # GET /welcome
  def index

  end

  def callback
  	puts 'In callback babeyeyyyyy'
  	puts params[:oauth_token]
  	puts params[:oauth_verifier]
  	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
	  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
	  config.access_token        = params[:oauth_token]
	end

	tweets = client.user_timeline("alexsideris_")
	puts tweets

	redirect_to "/lists"
  end

end
