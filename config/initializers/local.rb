require "socket"
HOSTNAME = if  Rails.env.production? then 'chris.boyle.name' else Socket::gethostname end
DOMAIN = if HOSTNAME.include? '.' then ".#{HOSTNAME}" else HOSTNAME end
ACCEPTABLE_HOSTNAMES = [HOSTNAME, 'ipv6.'+HOSTNAME]
AUTHOR_NAME = SITE_NAME = 'Chris Boyle'
EMAIL_SITE_NAME = 'chris.boyle.name'
BLOG_WORD = 'Blog'
PAGE_SIZE = 10
COPYRIGHT_YEARS = '2010-2011'
OPENID2_LOCAL_ID = 'https://profiles.google.com/chris.boyle.name'
OPENID2_PROVIDER = 'https://www.google.com/accounts/o8/ud?source=profiles'
BUG_TRACKER = 'http://github.com/chrisboyle/cbn/issues'
MAIL_FROM = 'blog@chris.boyle.name'
BCC = 'blog@chris.boyle.name'
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
XMLRPC_AUTH = YAML.load(File.read("#{RAILS_ROOT}/config/xmlrpc.yml"))

require 'resource_hacks_hack'
require 'authlogic_oauth_hacks'
require 'authlogic_secure_cookies'
require 'openid_force_ui_ext_hack'
require 'session_silent_read'

Haml::Template.options[:attr_wrapper] = '"'
Haml::Filters::CodeRay.encoder_options[:line_numbers] = :inline
ActionMailer::Base.delivery_method = :sendmail
ExceptionNotification::Notifier.exception_recipients = %w(chris@boyle.name)
ExceptionNotification::Notifier.sender_address = "\"Rails exception\" <rails-exception@chris.boyle.name>"
OpenIdAuthentication.store = OpenIdAuthentication::DbStore.new
OpenID.fetcher.ca_file = "/etc/ssl/certs/ca-certificates.crt"
