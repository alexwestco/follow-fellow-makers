class ListsController < ApplicationController

	def index
		@lists = List.all.reverse
	end

	def new
		@list = List.new
	end

	def create
	    @list = List.new(post_params)
	    if @list.save
	      	redirect_to "/"
	    else
	      	render 'new'
	    end
  	end

	def destroy
		@list = List.find(params[:id])

	    @list.destroy

	    redirect_to "/"
	end

	def edit
		@list = List.find(params[:id]) 
	end

  	def update
    	@list = List.find(params[:id])

    	if @list.update(post_params)
      		redirect_to "/"
    	else
      		render 'edit'
    	end
  	end

  	def show
  		@list = List.find(params[:id])
  	end

  	def follow

		puts 'hey'

		listmembers = client.list_members(params[:list], params[:owner])
		puts listmembers
		
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

  	private

	def post_params
		params.require(:list).permit(:name, :owner)
	end
end
