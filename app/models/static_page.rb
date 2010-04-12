class StaticPage < Page
	def to_param
		return name
	end
end
