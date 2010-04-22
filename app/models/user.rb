class User < ActiveRecord::Base
	has_many :users_roles
	has_many :roles, :through => :users_roles

	def role_symbols
		roles.map do |role|
			role.name.underscore.to_sym
		end
	end

	acts_as_authentic do |c|
		c.openid_required_fields = [:fullname, :email]
		# Email can be blank (even if not using OpenID)
		c.merge_validates_length_of_email_field_options(:allow_blank => true)
		c.merge_validates_format_of_email_field_options(:with => /^$|#{Authlogic::Regex.email}/)
		c.merge_validates_uniqueness_of_email_field_options(:allow_blank => true)
	end

	def before_connect(facebook_session)
		# TODO: multiple
		self.name = facebook_session.user.name
		self.url = facebook_session.user.profile_url
		self.reset_persistence_token
	end

	def self.get_twitter_user_find_or_create(token)
		profile = JSON.parse(token.get('/account/verify_credentials.json').body)
		find_or_create_by_twitter_username(:twitter_username => profile['screen_name'], :name => profile['name'])
	end

	private

	def map_openid_registration(registration)
		self.email = registration['email'] if email.blank?
	end
end
