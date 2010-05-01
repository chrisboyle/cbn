class FacebookUser
	def self.find(first,opts={})
		i = Identity.find_by_provider_and_identifier('facebook',opts[:conditions][:facebook_uid])
		@@last_ident = i if i
		i ? i.user : nil
	end

	def self.session_key=(val)
		@@last_ident && @@last_ident.secret = val
	end
end
