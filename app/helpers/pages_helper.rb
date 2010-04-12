module PagesHelper
	def edit_page_path(page)
		send("edit_#{page.class.name.underscore}_path", page)
	end
end
