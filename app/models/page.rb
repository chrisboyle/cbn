class Page < ActiveRecord::Base
	acts_as_tree
	validates_presence_of :title, :body
	has_many :comments
end
