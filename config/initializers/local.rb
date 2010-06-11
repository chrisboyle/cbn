AUTHOR_NAME = SITE_NAME = 'Chris Boyle'
EMAIL_SITE_NAME = 'chris.boyle.name'
BLOG_WORD = 'Blog'
MAIL_FROM = 'blog@chris.boyle.name'
BCC = 'blog@chris.boyle.name'
if Rails.env.production?
	ENV['HOSTNAME'] = 'chris.boyle.name'
end
LOGIN_BUTTONS = [
	['AOL','https://www.aol.com/'],
	['Blogger','http://username.blogspot.com/'],
	['Dreamwidth','http://username.dreamwidth.org/'],
	['Facebook',nil],
	['Flickr','http://flickr.com/username/'],
	['Google','https://www.google.com/accounts/o8/id'],
	['Insanejournal','http://username.insanejournal.com/'],
	['Livejournal','http://username.livejournal.com/'],
	['Wordpress','http://username.wordpress.com/'],
	['Twitter',nil],
	['Yahoo','https://www.yahoo.com/'],
]


GOOGLE_ANALYTICS = YAML.load(File.read("#{RAILS_ROOT}/config/google_analytics.yml"))
TWITTER = YAML.load(File.read("#{RAILS_ROOT}/config/twitter.yml"))

require 'resource_hacks_hack'
require 'authlogic_oauth_hacks'
require 'authlogic_secure_cookies'
require 'openid_force_ui_ext_hack'
require 'session_silent_read'

Haml::Template.options[:attr_wrapper] = '"'
Haml::Filters::CodeRay.encoder_options[:line_numbers] = :inline
ActionMailer::Base.delivery_method = :sendmail
OpenIdAuthentication.store = OpenIdAuthentication::DbStore.new
OpenID.fetcher.ca_file = "/etc/ssl/certs/ca-certificates.crt"
