class Page < ActiveRecord::Base
	validates_presence_of :title, :body
	validates_each :body do |record, attr, value|
		begin
			Haml::Engine.new(value, :format => :html5).render
		rescue Haml::Error => e
			record.errors.add attr, "line #{e.line || 'unknown'}: #{e.message}"
		end
	end
	has_many :comments
	def year
		created_at.year.to_s
	end
	def month
		'%02d' % created_at.month
	end
end
