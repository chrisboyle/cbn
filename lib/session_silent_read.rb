module ActionController
	module Session
		class AbstractStore
			class SessionHash
				def [](key)
					# avoid setting @loaded and therefore sending a cookie
					return nil if (@env[ENV_SESSION_OPTIONS_KEY][:secure] && @env['rack.url_scheme']=='http')
					load! unless @loaded
					super
				end
			end
		end
	end
end
