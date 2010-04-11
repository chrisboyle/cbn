atom_feed(:language => 'en-GB') do |feed|
	feed.title "Chris Boyle"
	feed.updated @pages.first.created_at

	@pages.each do |page|
		feed.entry page do |entry|
			entry.title page.title
			entry.content render(:partial => 'body.html', :format => 'html', :locals => { :body => page.body, :format => 'html' }), :type => 'html'
			entry.author { |author| author.name "Chris Boyle" }
		end
	end
end
