module UsersHelper
	def recognise_user(user)
		if user.facebook_uid then return ['facebook',nil] end
		if user.twitter_username then return ['twitter',nil] end
		case user.openid_identifier
		when /^https?:\/\/([^.]+)\.livejournal\.com\/$/ then ['livejournal', $1]
		when /^https?:\/\/([^.]+)\.insanejournal\.com\/$/ then ['insanejournal', $1]
		when /^https?:\/\/([^.]+)\.dreamwidth\.org\/$/ then ['dreamwidth', $1]
		when /^https?:\/\/(www\.)?google\.com\/accounts\// then ['google', 'anonymous']
		else sub(/^https?:\/\//,'').sub(/\/$/,'')
		end
	end

	def user_html(user)
		recog = recognise_user(user)
		if recog[0]
			content_tag(:span, image_tag("/images/sprites/user_#{recog[0]}.png") + (user.name || recog[1]), :class => 'userhtml')
		else
			content_tag(:span, 'logged in', :class => 'userhtml')
		end
	end
end
