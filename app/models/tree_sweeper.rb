class TreeSweeper < ActionController::Caching::Sweeper
	observe Page, Post, StaticPage, Project, ActsAsTaggableOn::Tag

	def after_save(record)
		expire_fragment 'tree'
	end

	def after_destroy(record)
		expire_fragment 'tree'
	end
end
