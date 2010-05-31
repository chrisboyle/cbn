class Page < ActiveRecord::Base
	validates_presence_of :title, :body
	validates_inclusion_of :type, :in => %w( StaticPage Post )
	validates_each :body do |record, attr, value|
		begin
			contr = PagesController.new()
			contr.response = ActionController::Response.new()
			scope = ActionView::Base.new(["#{RAILS_ROOT}/app/views/pages","#{RAILS_ROOT}/app/views"], {}, contr)
			scope.template_format = 'html'
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
			c.approved = Authorization::Engine.instance.permit? :skip_moderation, :context => :comments, :user => user
		end
	end
end
