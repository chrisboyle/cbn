# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include ExceptionNotification::Notifiable
	include SslRequirement

	helper :all # include all helpers, all the time
	helper_method :current_user
	protect_from_forgery # See ActionController::RequestForgeryProtection for details
	rescue_from ActionController::MethodNotAllowed do |e|
		render :file => Rails.root.join('public','405.html'), :status => 405
	end
	before_filter :canonicalise
	after_filter :x_ua_compatible
	after_filter :cache_control

	# Scrub sensitive parameters from your log
	filter_parameter_logging :password, :fb_sig_friends

	protected

	def ssl_required?
		(cookies[:secure_cookies_exist].present? && params[:format] != 'atom') || super
	end

	# N.B. This is whether SSL is optional, so must return *false* to force SSL
	def ssl_allowed?
		not ssl_required?
	end

	def default_url_options(options = {})
		if params[:format] == 'pdf' and options[:format] != :pdf
			options.merge!({:secure => false, :only_path => false})
		end
		if options[:year].is_a?(Post)
			post = options[:year]
			options.merge!({:year => post.year, :month => post.month, :name => post.name})
		elsif options[:id].is_a?(User) && options[:id]==current_user
			options.merge!({:id => 'current'})
		elsif options[:id].is_a?(ActsAsTaggableOn::Tag)
			options.merge!({:id => options[:id].name})
		elsif options[:acts_as_taggable_on_tag_id].is_a?(ActsAsTaggableOn::Tag)
			options.merge!({:acts_as_taggable_on_tag_id => options[:acts_as_taggable_on_tag_id].name})
		else
			{}
		end
	end

	def load_post
		if params[:year]
			@post = Post.year_month(params[:year],params[:month]).find_by_name(params[:name])
		end
		if not @post and params[:controller] != 'comments'
			raise ActiveRecord::RecordNotFound
		end
	end

	def rescue_action(e)
		case e
		when ActiveRecord::RecordNotFound, ActionController::RoutingError
			b = File.basename(request.request_uri)
			if not b.include? '/'
				p = Rails.root.join('public', 'download', b)
				if p.exist? and p.file?
					redirect_to "/download/#{b}", :status => :moved_permanently
					return
				end
				p = Rails.root.join('public', 'tmp', b)
				if p.exist? and p.file?
					redirect_to "/tmp/#{b}"
					return
				end
			end
			super(e)
		when Authorization::NotAuthorized
			permission_denied
		else
			super(e)
		end
	end

	def no_cache
		response.headers['Pragma'] = 'no-cache'
		response.headers['Expires'] = '0'
		response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate, pre-check=0, post-check=0'
	end

	# called by filter_access_to and by rescue_action
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
		login_page = url_for :controller => :user_sessions, :action => :new, :secure => true, :host => request.host
		respond_to do |format|
			format.html { redirect_to login_page }
			format.js { render(:update) {|p| p.redirect_to login_page }}
			format.all { render :file => "#{RAILS_ROOT}/public/403.html", :status => '403 Forbidden' }
		end
		no_cache
	end

	def load_user
		i = params[:user_id] || params[:id]
		if i == 'current'
			@user = current_user or raise Authorization::NotAuthorized
		else
			permitted_to! :show, User.new  # can't even access yourself by id
			@user = i ? User.find(i) : nil
		end
	end

	def load_tag
		t = params[:acts_as_taggable_on_tag_id] || params[:id]
		if t
			@tag = ActsAsTaggableOn::Tag.find_by_name(t)
			raise ActiveRecord::RecordNotFound unless @tag
		else
			@tag = nil
		end
	end

	def canonicalise
		p = request.path.sub(/\/+\Z/, '').sub(/\.html\Z/,'')
		if ENV['HOSTNAME'] and not [ENV['HOSTNAME'], 'ipv6.'+ENV['HOSTNAME']].include? request.host
			redirect_to 'http%s://%s:%d%s' % [request.ssl? ? 's' : '', ENV['HOSTNAME'], request.port, p]
		elsif p.present? && p != request.path
			redirect_to p, :status => 301
		end
	end

	def x_ua_compatible
		response.headers['X-UA-Compatible'] = 'IE=edge'
	end

	def cache_control
		unless request.ssl?
			# They can't be signed in; it's public
			response.headers['Cache-Control'] = 'public'
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
