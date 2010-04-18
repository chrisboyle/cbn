class UserSession < Authlogic::Session::Base
	auto_register
	# Don't spam the DB
	last_request_at_threshold 1.minute
end
