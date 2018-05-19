class SessionsController < ApplicationController
	def create
	  	auth_hash = request.env['omniauth.auth']
	  	session[:token] = auth_hash.credentials.token
	  	session[:secret] = auth_hash.credentials.secret
	  	session[:twitter_username] = auth_hash[:info][:name]
	  	redirect_to "/success"
	end

end