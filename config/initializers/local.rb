AUTHOR_NAME = SITE_NAME = 'Chris Boyle'
BLOG_WORD = 'Blog'

TWITTER = YAML.load(File.read("#{RAILS_ROOT}/config/twitter.yml"))

Haml::Template.options[:attr_wrapper] = '"'
Haml::Filters::CodeRay.encoder_options[:line_numbers] = :inline
ExceptionNotifier.exception_recipients = %w(chris@boyle.name)
ExceptionNotifier.sender_address = "\"Rails exception\" <rails-exception@chris.boyle.name>"
OpenIdAuthentication.store = OpenIdAuthentication::DbStore.new
OpenID.fetcher.ca_file = "/etc/ssl/certs/ca-certificates.crt"
