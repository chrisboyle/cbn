class Page < ActiveRecord::Base
	validates_presence_of :title, :body
	has_many :comments
end
