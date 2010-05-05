class Comment < ActiveRecord::Base
	belongs_to :page
	belongs_to :identity
	validates_presence_of :body
	validates_presence_of :identity
	validates_presence_of :page
	attr_accessible :body
	def user
		identity && identity.user
	end
end
