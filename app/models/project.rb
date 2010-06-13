class Project < ActiveRecord::Base
	acts_as_taggable
	validates_presence_of :title, :body
	STATUSES = %w( idea planning active maintenance abandoned )
	validates_inclusion_of :status, :in => STATUSES
	validates_each :body do |record, attr, value|
		begin
			contr = ProjectsController.new()
			contr.response = ActionController::Response.new()
			scope = ActionView::Base.new(["#{RAILS_ROOT}/app/views/projects","#{RAILS_ROOT}/app/views"], {}, contr)
			scope.template_format = 'html'
			Haml::Engine.new(value, :format => :html5).render(scope)
		rescue Exception => e
			record.errors.add attr, "line #{(e.respond_to? :line) && e.line || 'unknown'}: #{e.message}".sub('%','% ')
		end
	end

	def to_param
		name
	end
end
