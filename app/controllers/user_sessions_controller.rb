class UserSessionsController < ApplicationController
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
				# There's probably a better way to do this, but login_count is already 2 for OpenID (wtf)
				if current_user.created_at > 30.seconds.ago
					(Role.find_by_name('admin').users.collect &:email).each do |e|
						Mailer.deliver_signup_admin(current_user, e, url_for(:controller=>:users, :action=>:show, :id=>current_user.id)) unless e.blank?
					end
				end
				cookies[:secure_cookies_exist] = { :value => true, :httponly => true }
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
		cookies.delete :secure_cookies_exist
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
