# An implementation of the OpenID UI Extension 1.0
# see: http://openid.net/specs/

require 'openid/extension'

module OpenID

	module UI
		NS_URI = "http://specs.openid.net/extensions/ui/1.0"
		# A Provider Authentication Policy request, sent from a relying
		# party to a provider
		class Request < Extension
			attr_accessor :mode, :icon, :ns_alias, :ns_uri
			def initialize(mode=nil, icon=false)
				@ns_alias = 'ui'
				@ns_uri = NS_URI
				@mode = mode
				@icon = icon
			end

			def get_extension_args
				ns_args = {}
				ns_args['icon'] = 'true' if @icon
				ns_args['mode'] = @mode if @mode
				return ns_args
			end

			# Instantiate a Request object from the arguments in a
			# checkid_* OpenID message
			# return nil if the extension was not requested.
			def self.from_openid_request(oid_req)
				ui_req = new
				args = oid_req.message.get_args(NS_URI)
				if args == {}
					return nil
				end
				ui_req.parse_extension_args(args)
				return ui_req
			end

			# Set the state of this request to be that expressed in these
			# UI arguments
			def parse_extension_args(args)
				mode_str = args['mode']
				if mode_str
					@mode = mode_str
				else
					@mode = nil
				end

				icon_str = args['icon']
				if icon_str
					@icon = (icon_str.to_s == 'false') ? nil : true
				else
					@icon = nil
				end
			end
		end

	end

end
