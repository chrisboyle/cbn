module Authlogic
	module Session
		module Cookies
			module InstanceMethods
				private
				def save_cookie
					controller.cookies[cookie_key] = {
						:value => "#{record.persistence_token}::#{record.send(record.class.primary_key)}",
						:expires => remember_me_until,
						:domain => controller.cookie_domain,
						# This file is here to add these two options:
						:secure => Rails.env.production?,
						:httponly => true
					}
				end
			end
		end
	end
end
