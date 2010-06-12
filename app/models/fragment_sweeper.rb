class FragmentSweeper < ActionController::Caching::Sweeper
	observe Post, StaticPage, Comment

	def before_update(record)
		expire_fragment(record.cache_key)
		expire_fragment(record.cache_key+'-c')
	end

	def after_destroy(record)
		expire_fragment(record.cache_key)
		expire_fragment(record.cache_key+'-c')
	end
end
