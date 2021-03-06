class UserSession < Authlogic::Session::Base
	auto_register
	# Don't spam the DB
	last_request_at_threshold 1.minute
	facebook_auth_if :login_with_facebook?
	find_by_oauth_method :get_twitter_user_find_or_create
	facebook_user_class FacebookUser

	def self.oauth_consumer
		OAuth::Consumer.new(TWITTER['token'], TWITTER['secret'], {
				:site=>"http://twitter.com",
				:authorize_url => "http://twitter.com/oauth/authorize?force_login=true" })
	end

	private

	def login_with_facebook?
		controller.params[:login_with_facebook].present?
	end
end
