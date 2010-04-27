class User < ActiveRecord::Base
	has_many :users_roles
	has_many :roles, :through => :users_roles
	has_many :identities
	belongs_to :default_identity, :class_name => 'Identity'

	acts_as_authentic do |c|
		c.openid_required_fields = ['fullname', 'http://schema.openid.net/namePerson', 'http://axschema.org/namePerson']
		c.openid_optional_fields = ['email',
				'http://schema.openid.net/contact/email', 'http://axschema.org/contact/email',
				'http://schema.openid.net/contact/web/blog', 'http://axschema.org/contact/web/blog',
				'http://schema.openid.net/contact/web/default', 'http://axschema.org/contact/web/default']
		# Email can be blank (even if not using OpenID)
		c.merge_validates_length_of_email_field_options(:allow_blank => true)
		c.merge_validates_format_of_email_field_options(:with => /^$|#{Authlogic::Regex.email}/)
		c.merge_validates_uniqueness_of_email_field_options(:allow_blank => true)
	end

	def role_symbols
		[:user] + roles.map do |role|
			role.name.underscore.to_sym
		end
	end

	def login
		email
	end

	def identity
		default_identity || identities.first
	end

	def self.get_twitter_user_find_or_create(token)
		profile = JSON.parse(token.get('/account/verify_credentials.json').body)
		i = Identity.find_or_create_by_provider_and_identifier('twitter', profile['screen_name']) do |i|
			i.name = profile['name']
			i.display_name = profile['screen_name']
		end
		i.user ||= User.new(:default_identity => i)
		i.user.reset_persistence_token
	end

	def self.find_by_openid_identifier(ident)
		i = Identity.find_by_provider_and_identifier('openid',ident)
		i ? i.user : nil
	end

	def openid_identifier=(ident)
		i = Identity.find_or_create_by_provider_and_identifier('openid', ident) do |i|
			i.display_name = ident.sub(/^https?:\/\//,'').sub(/\/$/,'')
		end
		identities << i
		default_identity ||= i
	end

	def before_connect(facebook_session)
		name = facebook_session.user.name
		url = facebook_session.user.profile_url
		identities << Identity.new(:name => name, :display_name => name, :url => url)
		default_identity ||= identities[0]
		reset_persistence_token
	end

	private

	def map_openid_registration(r)
		#email = r['http://schema.openid.net/contact/email'] || r['http://axschema.org/contact/email'] || r['email'] if email.blank?
		email = r['email'] if email.blank?
	end
end
