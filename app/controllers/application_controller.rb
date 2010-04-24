# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include ExceptionNotifiable
	helper :all # include all helpers, all the time
	helper_method :current_user
	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password, :fb_sig_friends

	alias_method :pages_path, :root_path

	protected

	def default_url_options(options = {})
		if options[:year].is_a?(Post)
			page = options[:year]
			options.merge!({:year => page.year, :month => page.month, :name => page.name})
		else
			{}
		end
	end

	def _rescue_action(e)
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

	private
	def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session = UserSession.find
	end

	def current_user
		@current_user = current_user_session && current_user_session.record
	end
end
