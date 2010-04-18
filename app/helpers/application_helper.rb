# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def title(t)
		content_for :title, t
	end

	def titleh1(t)
		title(t)
		content_tag(:h1, t)
	end
end

class Time
	def friendly8601
		strftime('%Y-%m-%d %H:%M:%S')
	end
end
