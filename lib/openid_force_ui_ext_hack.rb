# Hack to force openid.ui.icon = true for all checkid requests
require 'openid/extensions/ui'
module OpenID
	class Consumer
		def begin(openid_identifier, anonymous=false)
			manager = discovery_manager(openid_identifier)
			service = manager.get_next_service(&method(:discover))

			if service.nil?
				raise DiscoveryFailure.new("No usable OpenID services were found "\
										   "for #{openid_identifier.inspect}", nil)
			else
				returning begin_without_discovery(service, anonymous) do |r|
					r.add_extension(::OpenID::UI::Request.new(nil, true))
				end
			end
		end
	end
end
