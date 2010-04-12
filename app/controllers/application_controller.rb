# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include ExceptionNotifiable
	helper :all # include all helpers, all the time
	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password

	protected

	def url_for(options = {})
		if options[:year].class.to_s == 'Post'
			page = options[:year]
			options[:year] = page.created_at.year
			options[:month] = '%02d' % page.created_at.month
			options[:name] = page.name
		end
		super(options)
	end

	def rescue_action(e)
		case e
		when ActiveRecord::RecordNotFound
			respond_to do |format|
				format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => '404 Not Found' } 
				format.xml  { render :nothing => true, :status => '404 Not Found' } 
			end
		else
			super
		end
	end
end
