# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def title(t)
		content_for :title, t
	end
end
