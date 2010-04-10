atom_feed do |feed|
	feed.title "Chris Boyle"
	feed.updated @pages.first.created_at

	@pages.each do |page|
		next unless page.blog
		feed.entry page do |entry|
			entry.title page.title
			entry.content page.body, :type => 'html'
			entry.author { |author| author.name "Chris Boyle" }
		end
	end
end
