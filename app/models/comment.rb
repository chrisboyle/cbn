class Comment < ActiveRecord::Base
	belongs_to :page
	belongs_to :user
	validates_presence_of :body
end
