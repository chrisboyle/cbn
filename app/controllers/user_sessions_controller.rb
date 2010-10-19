class UserSessionsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => :create  # OpenID will POST big requests

	def new
		@user_session = UserSession.new
	end

	def create
		# Give normalization a little help: people might not enter http://
		if params[:user_session]
			openid = params[:user_session]['openid_identifier']
			if openid and /^[^=@+!]/.match(openid) and not /^[a-z0-9]+:/.match(openid)
				params[:user_session]['openid_identifier'] = 'http://'+openid
			end
		end
		session[:next] = params[:next] if params[:next]
		login_with = params.keys.find{|x| x[0..10]=='login_with_'}
		login_with = login_with[11..-1] if login_with
		@user_session = UserSession.new(params[:user_session])
		if login_with and not %w(facebook oauth).include? login_with
			# An OpenID button was clicked without JS
			site, url = LOGIN_BUTTONS.find {|x| x[0].downcase == login_with }
			if url
				@user_session.openid_identifier = url
				if /username/.match url
					@username_prompt = true
					render 'new'
					return
				end
			end
		end
		@user_session.save do |result|
			if result
				u = current_user
				# There's probably a better way to do this, but login_count is already 2 for OpenID (wtf)
				if u.created_at > 30.seconds.ago
					it = u.identity.icon_and_text
					key = [it[0], (%w(dreamwidth insanejournal livejournal).include? it[0]) ? it[1] : u.identity.identifier]
					friendships = Rails.root.join('config', 'friendships')
					if friendships.file? and friendships.readable? and friendships.readlines.collect {|l| l.chomp.split(' ')}.include? key
						u.roles << Role.find_by_name('known')
						u.save
					end
					(Role.find_by_name('admin').users.collect &:email).each do |e|
						Mailer.deliver_signup_admin(u, e, url_for(:controller=>:users, :action=>:show, :id=>u.id)) unless e.blank?
					end
				end
				# TODO: respect Authlogic's cookie expiry time (3 months is the default)
				cookies[:secure_cookies_exist] = { :value => true, :httponly => true, :domain => '.'+ENV['HOSTNAME'], :expires => @user_session.remember_me ? 3.months.from_now : nil }
				flash[:notice] = "Successfully signed in."
				redirect_to session.delete(:next) || root_url
			else
				render 'new'
			end
		end
	end

	def destroy
		@user_session = UserSession.find
		@user_session.destroy if @user_session
		flash[:notice] = "Successfully signed out."
		cookies.delete :secure_cookies_exist, :domain => '.'+ENV['HOSTNAME']
		redirect_to(params[:next] || :back)
	end

	def show
		if current_user
			redirect_to :controller => :users, :action => :show, :id => 'current'
		else
			redirect_to :action => :new
		end
	end

	protected

	# Wrapper to record changes to sreg/ax data on second and subsequent logins
	def authenticate_with_open_id(identifier = nil, options = {}, &block)
		wrapped = lambda { |result, openid_identifier, registration|
			existed_before = User.find_by_openid_identifier(openid_identifier)
			block.call(result, openid_identifier, registration)
			return if result.unsuccessful? or not existed_before
			@user_session.attempted_record.map_openid_registration(registration)
		}
		super(identifier, options, &wrapped)
	end

	def ssl_required?
		true
	end
end
