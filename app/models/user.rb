class User < ActiveRecord::Base
	acts_as_authentic do |c|
		c.openid_required_fields = [:fullname, :email]
	end
end
