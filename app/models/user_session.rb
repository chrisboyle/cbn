class UserSession < Authlogic::Session::Base
	auto_register
	# Don't spam the DB
	last_request_at_threshold 1.minute
	facebook_auth_if :auth_using_fb

	private

	def auth_using_fb
		controller.params[:auth_using_fb].present?
	end
end
