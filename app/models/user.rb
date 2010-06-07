class User < ActiveRecord::Base
	has_many :users_roles
	has_many :roles, :through => :users_roles
	has_many :identities
	has_many :comments, :through => :identities
	belongs_to :default_identity, :class_name => 'Identity'
	validates_each :default_identity_id do |record, attr, value|
		record.errors.add attr, 'must be one of yours' unless record.identity_ids.include? value
	end

	attr_accessible :email, :mail_on_edit, :mail_on_reply, :mail_on_thread, :mail_on_post, :default_identity_id

	acts_as_authentic do |c|
		c.openid_required_fields = ['fullname', 'http://schema.openid.net/namePerson', 'http://axschema.org/namePerson',
				'http://schema.openid.net/namePerson/last', 'http://axschema.org/namePerson/last',
				'http://schema.openid.net/namePerson/first', 'http://axschema.org/namePerson/first']
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

	def mailable?
		not email.blank? and Authorization::Engine.instance.permit? :receive, :context => :notifications, :user => self
	end

	def identity_id
		default_identity_id || identity_ids.first
	end
	def identity
		default_identity || identities.first
	end

	def self.get_twitter_user_find_or_create(token)
		profile = JSON.parse(token.get('/account/verify_credentials.json').body)
		i = Identity.find_or_create_by_provider_and_identifier('twitter', profile['screen_name']) do |i|
			i.name = profile['name']
			i.display_name = profile['screen_name']
			i.guess_urls
		end
		i.user ||= User.new(:default_identity => i) do |u|
			u.reset_persistence_token
		end
	end

	def self.find_by_openid_identifier(ident)
		i = Identity.find_by_provider_and_identifier('openid',ident)
		@@last_openid_ident = i  # HACK...
		i ? i.user : nil
	end

	def openid_identifier=(ident)
		returning ident do
			i = Identity.find_or_create_by_provider_and_identifier('openid', ident) do |i|
				i.display_name = ident.sub(/^https?:\/\//,'').sub(/\/$/,'')
				i.guess_urls
			end
			identities << i
			@@last_openid_ident = i  # HACK...
			self.default_identity ||= i
		end
	end

	def before_connect(sess)
		i = Identity.find_or_create_by_provider_and_identifier('facebook', sess.user.uid.to_s) do |i|
			i.secret = sess.session_key
		end
		i.display_name = sess.user.name
		i.name         = sess.user.name
		i.url          = sess.user.profile_url
		reset_persistence_token
	end

	def facebook_session_key=(val)
		FacebookUser.session_key = val
	end

	def map_openid_registration(r)
		email_ = r['http://schema.openid.net/contact/email'] || r['http://axschema.org/contact/email'] || r['email']
		email = email_ if email_
		if @@last_openid_ident
			name = r['http://schema.openid.net/namePerson'] || r['http://axschema.org/namePerson'] || r['fullname']
			name = name.to_s if name
			if not name or name.blank?
				first = r['http://schema.openid.net/namePerson/first'] || r['http://axschema.org/namePerson/first'] || r['firstname']
				last  = r['http://schema.openid.net/namePerson/last' ] || r['http://axschema.org/namePerson/last' ] || r['lastname']
				name  = [first,last].find_all{|e| e }.join(' ')
			end
			if name and not name.blank?
				@@last_openid_ident.name = name
				@@last_openid_ident.display_name = name
				@@last_openid_ident.save
			end
			url_ = r['http://schema.openid.net/contact/web/blog'] || r['http://axschema.org/contact/web/blog'] ||r['http://schema.openid.net/contact/web/default'] || r['http://axschema.org/contact/web/default'] || r['url']
			url = url_ if url_
		end
	end

	def build_facebook_user(opts={})
		i = Identity.find_or_create_by_provider_and_identifier('facebook', opts[:facebook_uid]) do |i|
			i.secret = opts[:facebook_session_key]
		end
		self.identities << i
		self.default_identity ||= i
	end
end
