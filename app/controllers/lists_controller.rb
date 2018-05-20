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
		@users = []
		listmembers.each do |lmname|
			@users.push(lmname.screen_name)
			p lmname.screen_name
			p lmname.followers_count
			p lmname.statuses_count

			$i = $i+1
			puts $i

			if $i == Integer(params[:number])
				break
			end

		end

		session[:users] = @users
	
	end

	def follow
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
		  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
		  config.access_token        = session[:token]
	  	  config.access_token_secret = session[:secret]
	  	end

	  	session[:users].each do |lmname|
	  		client.follow(lmname)
	  	end

	  	session[:users] = []

	  	redirect_to "/success"
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
