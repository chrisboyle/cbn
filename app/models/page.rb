class Page < ActiveRecord::Base
	validates_presence_of :title, :body
	validates_inclusion_of :type, :in => %w( StaticPage Post )
	validates_each :body do |record, attr, value|
		begin
			base = ActionView::Base.new('/app/views/pages', {}, PagesController)
			Haml::Engine.new(value, :format => :html5).render(base)
		rescue Exception => e
			record.errors.add attr, "line #{(e.respond_to? :line) && e.line || 'unknown'}: #{e.message}"
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
