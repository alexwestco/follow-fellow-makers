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

  	def follow
		puts session[:token]
		puts session[:secret]
		puts session[:twitter_username]

		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_KEY')
		  config.consumer_secret     = ENV.fetch('FOLLOW_FELLOW_FOUNDERS_CONSUMER_SECRET')
		  config.access_token        = session[:token]
	  	  config.access_token_secret = session[:secret]
	  	end

	  	puts params[:list_slug_name]
	  	puts params[:list_owner_name]
	  	puts params[:number]
	  	puts params[:type]

		listmembers = client.list_members(params[:list_owner_name], params[:list_slug_name])
		puts listmembers
		
		# Maybe sort users in some way according to filter options, like followers and startuses

		$i = 0
		listmembers.each do |lmname|
			p lmname.screen_name
			p lmname.followers_count
			p lmname.statuses_count
			#puts client.follow(lmname.screen_name)
			puts i
			$i = $i+1
			if $i == params[:number]
				puts 'break'
				break
			end
		end
		puts i

		redirect_to '/success'
		
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
