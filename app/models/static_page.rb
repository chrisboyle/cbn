class StaticPage < ActiveRecord::Base
	validates_presence_of :name, :title, :body
	validates_each :body do |record, attr, value|
		begin
			contr = StaticPagesController.new()
			contr.response = ActionController::Response.new()
			scope = ActionView::Base.new(["#{RAILS_ROOT}/app/views/static_pages","#{RAILS_ROOT}/app/views"], {}, contr)
			scope.template_format = 'html'
			Haml::Engine.new(value, :format => :html5).render(scope)
		rescue Exception => e
			record.errors.add attr, "line #{(e.respond_to? :line) && e.line || 'unknown'}: #{e.message}".sub('%','% ')
		end
	end

	def to_param
		name
	end

	named_scope :by_draft, Proc.new {|d|
		{:conditions => ['draft = ?', d]}
	}
end
