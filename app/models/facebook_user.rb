class FacebookUser
	def self.find(first,opts={})
		i = Identity.find_by_provider_and_identifier('facebook',opts[:conditions][:facebook_uid])
		i ? i.user : nil
	end
end
