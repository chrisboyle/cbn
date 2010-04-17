class UserSessionsController < ApplicationController
	def new
		@user_session = UserSession.new
	end

	def create
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
end
