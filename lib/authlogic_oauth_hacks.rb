module AuthlogicOauth
	module OauthProcess
		private
		def build_callback_url
			oauth_controller.url_for :controller => oauth_controller.controller_name, :action => oauth_controller.action_name,
				# HACK: support remember_me
				:remember_me => oauth_controller.params[:user_session][:remember_me]
		end
	end

	module Session
		module Methods
			private
			def authenticate_with_oauth
				if @record
					self.attempted_record = record
				else
					# HACK: s/generate_access_token.token/generate_access_token/ - needed to get twitter username
					self.attempted_record = search_for_record(find_by_oauth_method, generate_access_token)
				end
				# HACK: support remember_me
				self.remember_me = !controller.params[:remember_me].to_i.zero? if controller.params.key?(:remember_me)

				if !attempted_record
					errors.add_to_base("Internal error, twitter find_or_create failed.")
				end
			end
		end
	end
end
