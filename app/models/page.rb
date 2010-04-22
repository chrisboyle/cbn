class Page < ActiveRecord::Base
	validates_presence_of :title, :body
	has_many :comments
	def year
		created_at.year.to_s
	end
	def month
		'%02d' % created_at.month
	end
end
