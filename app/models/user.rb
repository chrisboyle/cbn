class User < ActiveRecord::Base
	acts_as_authentic do |c|
		c.openid_required_fields = [:fullname, :email]
		# Email can be blank (even if not using OpenID)
		c.merge_validates_length_of_email_field_options(:allow_blank => true)
		c.merge_validates_format_of_email_field_options(:with => /^$|#{Authlogic::Regex.email}/)
		c.merge_validates_uniqueness_of_email_field_options(:allow_blank => true)
	end

	private

	def map_openid_registration(registration)
		self.email = registration['email'] if email.blank?
	end
end
