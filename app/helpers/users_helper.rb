module UsersHelper
	def recognise_user(user)
		if user.facebook_uid then return ['facebook',nil] end
		if user.twitter_username then return ['twitter',nil] end
		case user.openid_identifier
		when nil then nil
		when /^https?:\/\/([^.]+)\.livejournal\.com\/$/ then ['livejournal', $1]
		when /^https?:\/\/([^.]+)\.insanejournal\.com\/$/ then ['insanejournal', $1]
		when /^https?:\/\/([^.]+)\.dreamwidth\.org\/$/ then ['dreamwidth', $1]
		when /^https?:\/\/(www\.)?google\.com\/accounts\// then ['google', 'anonymous']
		else sub(/^https?:\/\//,'').sub(/\/$/,'')
		end
	end

	def user_html(user)
		recog = recognise_user(user)
		t = user.name || recog[1] || 'logged in'
		if recog[0]
			t = image_tag("/images/sprites/user_#{recog[0]}.png") + t
		end
		u = content_tag(:span, t, :class => 'userhtml')
		if user.url
			link_to u, user.url
		else
			u
		end
	end
end
