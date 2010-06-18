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

	def downloads
		return nil unless filename_start.present?
		files = Rails.root.join('public', 'download').children.select do |f|
			# version doubling as regex is a bit of a hack, but works (dots might be any character, dashes etc likely to be unchanged)
			# TODO fix this for things like "1.23[beta] (final?)"
			f.file? and f.readable? and f.basename.to_s.downcase.starts_with? filename_start.downcase and Regexp.new(version).match f.basename
		end
		ret = {:bin => [], :src => [], :sig => {}}
		bin, src, sig = [], [], {}
		files.each do |f|
			case f.extname
			when *%w(.gz .tgz .tbz .rb .py .pl .js .c .cpp) then src << f
			when *%w(.apk .deb .ko .so) then bin << f
			when *%w(.asc) then sig[f.to_s[0..-5]] = f
			end
		end
		[bin.sort + src.sort, sig]
	end
end
