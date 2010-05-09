# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include ExceptionNotification::Notifiable
	helper :all # include all helpers, all the time
	helper_method :current_user
	protect_from_forgery # See ActionController::RequestForgeryProtection for details

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password, :fb_sig_friends

	protected

	def default_url_options(options = {})
		if options[:year].is_a?(Post)
			page = options[:year]
			options.merge!({:year => page.year, :month => page.month, :name => page.name})
		elsif options[:id].is_a?(User) && options[:id]==current_user
			options.merge!({:id => 'current'})
		else
			{}
		end
	end

	def load_page
		if params[:year]
			start = Time.local(params[:year], params[:month])
			finish = start.end_of_month.end_of_day
			@page = Page.first(:conditions => ['created_at > ? and created_at < ? and name = ?', start, finish, params[:name]])
		else
			@page = Page.find_by_name(params[:name])
		end
		if not @page and params[:controller] != 'comments'
			raise ActiveRecord::RecordNotFound
		end
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

	def permission_denied
		if current_user
			flash[:warning] = "Sorry, your account is not allowed to do that. Try another?"
		else
			flash[:notice] = "To do that, I need to know who you are."
		end
		if request.request_method == :get
			session[:next] = request.request_uri
		else
			session.delete(:next)
		end
		loginpage = url_for :controller => :user_sessions, :action => :new
		respond_to do |format|
			format.html { redirect_to loginpage }
			format.js { render(:update) {|p| p.redirect_to loginpage }}
			format.all { render :file => "#{RAILS_ROOT}/public/403.html", :status => '403 Forbidden' }
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
