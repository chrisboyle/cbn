atom_feed(:language => 'en-GB', :root_url => @tag ? acts_as_taggable_on_tag_url(@tag) : root_url) do |feed|
	feed.title ((@tag ? "Tag \"#{@tag.name}\" - " : "") + SITE_NAME)
	feed.updated @posts.present? ? @posts.first.created_at : Time.now

	@posts.each do |post|
		feed.entry post, :url => post_url(post, :secure => false, :host => request.host) do |entry|
			entry.title post.title
			entry.content render(:partial => 'common/body.html', :object => post.body) + render(:partial => 'feedfooter.html', :object => post), :type => 'html'
			entry.author { |author| author.name AUTHOR_NAME }
		end
	end
end
