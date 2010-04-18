# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
	# The OpenID DbStore classes should not be reloaded when vendor/plugins
	# isn't, or chaos will result
	config.load_once_paths += %W( #{RAILS_ROOT}/lib )

	# Cause a lot fewer http requests
	config.gem "auto_sprite"

	# Pretty code samples
	config.gem "coderay"
	config.gem "haml-coderay"

	# Authentication
	config.gem "authlogic"
	config.gem "ruby-openid", :lib => "openid"
	# (also vendor/plugins/open_id_authentication)
	config.gem "facebooker"

	config.time_zone = 'London'
end
