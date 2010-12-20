class Post < ActiveRecord::Base
	acts_as_taggable
	validates_format_of :tag_list, :with => /\A[A-Za-z0-9, _+-]*\Z/
	validates_presence_of :name, :title, :body
	validates_each :body do |record, attr, value|
		begin
			contr = PostsController.new()
			contr.response = ActionController::Response.new()
			scope = ActionView::Base.new(["#{RAILS_ROOT}/app/views/posts","#{RAILS_ROOT}/app/views"], {}, contr)
			scope.template_format = 'html'
			Haml::Engine.new(value, :format => :html5).render(scope)
		rescue Exception => e
			record.errors.add attr, "line #{(e.respond_to? :line) && e.line || 'unknown'}: #{e.message}".sub('%','% ')
		end
	end
	has_many :comments

	named_scope :year_month, Proc.new {|year,month|
		start = Time.zone.local(year, month)
		finish = month ? start.end_of_month.end_of_day : start.end_of_year.end_of_day
		{:conditions => ['created_at > ? and created_at < ?', start, finish]}
	}

	named_scope :before_after, Proc.new {|before,after|
		{:conditions => merge_conditions(
				before && ['created_at < ?', before],
				after  && ['created_at > ?', after])}
	}

	named_scope :by_draft, Proc.new {|d|
		{:conditions => ['draft = ?', d]}
	}

	def year
		created_at.year.to_s
	end

	def month
		'%02d' % created_at.month
	end

	def comment_from(user)
		returning Comment.new do |c|
			c.post = self
			c.identity = user.identity if user
			c.approved = Authorization::Engine.instance.permit? :skip_moderation, :context => :comments, :user => user
		end
	end
end
