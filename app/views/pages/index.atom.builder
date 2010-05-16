atom_feed(:language => 'en-GB') do |feed|
	feed.title SITE_NAME
	feed.updated @pages.first.created_at

	@pages.each do |page|
		feed.entry page do |entry|
			entry.title page.title
			entry.content render(:partial => 'body.html', :object => page.body) + render(:partial => 'feedfooter.html', :object => page), :type => 'html'
			entry.author { |author| author.name AUTHOR_NAME }
		end
	end
end
