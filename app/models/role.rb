class Role < ActiveRecord::Base
	has_many :users_roles
	has_many :users, :through => :users_roles
	def description
		{
			'admin'     => 'Administrator',
			'moderator' => 'Approve comments',
			'known'     => 'Publish comments immediately',
		}.fetch(name, name)
	end
end
