class TreeSweeper < ActionController::Caching::Sweeper
	observe Post, StaticPage, Project, ActsAsTaggableOn::Tag

	def after_save(record)
		expire_fragment 'tree'
		expire_fragment 'tree-admin'
	end

	def after_destroy(record)
		expire_fragment 'tree'
		expire_fragment 'tree-admin'
	end
end
