class Page < ActiveRecord::Base
	validates_presence_of :title, :body
	validates_inclusion_of :type, :in => %w( StaticPage Post )
	class << self
		attr_writer :renderscope
	end
	validates_each :body do |record, attr, value|
		begin
			scope = @renderscope || ActionView::Base.new(['/app/views/pages','/app/views'], {}, PagesController)
			Haml::Engine.new(value, :format => :html5).render(scope)
		rescue Exception => e
			record.errors.add attr, "line #{(e.respond_to? :line) && e.line || 'unknown'}: #{e.message}".sub('%','% ')
		end
	end
	has_many :comments
	def year
		created_at.year.to_s
	end
	def month
		'%02d' % created_at.month
	end

	def comment_from(user)
		returning Comment.new do |c|
			c.page = self
			c.identity = user.identity if user
			c.approved = user.role_symbols.include? :known if user
		end
	end
end
