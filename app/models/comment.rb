class Comment < ActiveRecord::Base
	belongs_to :page
	belongs_to :identity
	validates_presence_of :body
	def user
		identity && identity.user
	end
end
