atom_feed(:language => 'en-GB') do |feed|
	feed.title SITE_NAME
	feed.updated @posts.present? ? @posts.first.created_at : Time.now

	@posts.each do |post|
		feed.entry post, :url => post_url(post, :secure => false, :host => request.host) do |entry|
			entry.title post.title
			entry.content render(:partial => 'common/body.html', :object => post.body) + render(:partial => 'feedfooter.html', :object => post), :type => 'html'
			entry.author { |author| author.name AUTHOR_NAME }
		end
	end
end
