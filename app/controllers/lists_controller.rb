class ListsController < ApplicationController
	before_action :check_session

	def index
		@lists = List.all.reverse
	end

	def new
		@list = List.new
	end

	def create
	    @list = List.new(post_params)

	    # Check if this list already exists
	    record = List.where(:name => post_params[:name], :owner => post_params[:owner]).first
	    
	    # It exists
	    if record != nil
	    	redirect_to '/lists'
	    end

	  	# It doesn't exist

	  	# Check if the list exists on Twitter
		begin
		    client = Twitter::REST::Client.new do |config|
			  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
			  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
			  config.access_token        = session[:token]
		  	  config.access_token_secret = session[:secret]
		  	end
		  	# This will raise a 500 error
		  	listmembers = client.list_members(post_params[:owner], post_params[:name])
		  	
		  	# No error was raised, create the list
		  	if @list.save
		      	redirect_to "/"
		    else
		      	render 'new'
		    end
		rescue Twitter::Error::NotFound => e
		    # if list is not found
		    redirect_to '/lists'
		end
	  	
  	end

  	def get_users

		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
		  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
		  config.access_token        = session[:token]
	  	  config.access_token_secret = session[:secret]
	  	end

		listmembers = client.list_members(params[:list_owner], params[:list_name])
		# Maybe sort users in some way according to filter options, like followers and startuses

		$i = 0
		@all_users = []
		listmembers.each do |lmname|

			user = User.new
			user.twitter_username = lmname.screen_name
			user.follower_count = lmname.followers_count
			user.tweet_count = lmname.statuses_count

			user.bio = lmname.description
			user.image_url = lmname.profile_image_url
			
			@all_users.push(user)

		end

		@text = ''

		if params[:type] == 'popular'
			@text = 'These are the '+params[:number]+' most popular makers on '+params[:list_name]
			@all_users = @all_users.sort_by(&:follower_count).reverse
		elsif params[:type] == 'active'
			@text = 'These are the '+params[:number]+' most active makers on '+params[:list_name]
			@all_users = @all_users.sort_by(&:tweet_count).reverse
		else
			@text = 'These are '+params[:number]+' random makers on '+params[:list_name]
			@all_users = @all_users.shuffle
		end

		@users = @all_users.first(Integer(params[:number]))
	
	end

	def follow
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
		  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
		  config.access_token        = session[:token]
	  	  config.access_token_secret = session[:secret]
	  	end

	  	JSON.parse(params[:users]).each do |user|
	  		client.follow(user['twitter_username'])
	  	end

	  	redirect_to "/lists/success"
	end

	def success

	end

  	private

  	def check_session
  		if session[:token] == '' || session[:secret] == '' || session[:twitter_username] == ''
			redirect_to '/'
		end
  	end

	def post_params
		params.require(:list).permit(:name, :owner)
	end
end
