class UserSessionsController < ApplicationController
	def new
		@user_session = UserSession.new
	end

	def create
		# Give normalization a little help: people might not enter http://
		if params[:user_session]
			openid = params[:user_session]['openid_identifier']
			if openid and /^[^=@+!]/.match(openid) and not /^[a-z0-9]+:/.match(openid)
				params[:user_session]['openid_identifier'] = 'http://'+openid
			end
		end
		@user_session = UserSession.new(params[:user_session])
		@user_session.save do |result|
			if result
				flash[:notice] = "Successfully logged in."
				redirect_to root_url
			else
				render :action => 'new'
			end
		end
	end

	def destroy
		@user_session = UserSession.find
		@user_session.destroy
		flash[:notice] = "Successfully logged out."
		redirect_to root_url
	end
end
