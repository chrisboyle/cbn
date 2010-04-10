# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include ExceptionNotifiable
	helper :all # include all helpers, all the time
	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password

	def url_for(options = {})
		if options[:year].class.to_s == 'Page'
			page = options[:year]
			options[:year] = page.created_at.year
			options[:month] = '%02d' % page.created_at.month
			options[:name] = page.name
		end
		super(options)
	end
end
