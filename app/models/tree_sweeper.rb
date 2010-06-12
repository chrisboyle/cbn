class TreeSweeper < ActionController::Caching::Sweeper
	observe Post, StaticPage, Project, ActsAsTaggableOn::Tag

	def after_save(record)
		expire_fragment 'tree'
	end

	def after_destroy(record)
		expire_fragment 'tree'
	end
end
