class StaticPage < Page
	def to_param
		name
	end
end
