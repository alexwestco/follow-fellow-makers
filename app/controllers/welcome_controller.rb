require "net/http"

class WelcomeController < ApplicationController

  # GET /welcome
  def index
  	
  end

  def follow
  	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
	  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
	  config.access_token        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_ACCESS_TOKEN')
	  config.access_token_secret = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_ACCESS_TOKEN_SECRET')
	end

	puts 'hey'

	listmembers = client.list_members(params[:list], params[:owner])
	
	# Maybe sort users in some way according to filter options, like followers and startuses

	i = 0
	listmembers.each do |lmname| 
		p lmname.screen_name
		p lmname.followers_count
		p lmname.statuses_count
		#puts client.follow(lmname.screen_name)
		i = i+1
		if i == params[:number]
			break
		end
	end
	puts i
	
  end

end
