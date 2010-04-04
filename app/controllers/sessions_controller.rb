class SessionsController < ApplicationController
	def create
		authenticate_with_open_id do |result, id_url|
			if result.successful?
				if id = User.find_by_identity(id_url)
					session[:user_id] = id
				else
					# make one...
				end
				redirect_to root_url
			else
				flash[:error] = result.message
				redirect_to new_session_url
			end
		end
	end
end
