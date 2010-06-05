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
		@user_session = UserSession.new(params[:user_session])
		@user_session.save do |result|
			if result
				cookies[:secure_cookies_exist] = { :value => true, :httponly => true }
				flash[:notice] = "Successfully signed in."
				redirect_to session.delete(:next) || root_url
			else
				render :action => 'new'
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
