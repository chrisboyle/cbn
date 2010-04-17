AUTHOR_NAME = SITE_NAME = 'Chris Boyle'
BLOG_WORD = 'Blog'

Haml::Template.options[:attr_wrapper] = '"'
Haml::Filters::CodeRay.encoder_options[:line_numbers] = :inline
ExceptionNotifier.exception_recipients = %w(chris@boyle.name)
ExceptionNotifier.sender_address = "\"Rails exception\" <rails-exception@chris.boyle.name>"
OpenIdAuthentication.store = OpenIdAuthentication::DbStore.new
