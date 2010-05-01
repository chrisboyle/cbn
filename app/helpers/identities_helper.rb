module IdentitiesHelper
	def ident_html(i)
		icon, text = *i.icon_and_text
		if i.url
			text = link_to text, i.url, :rel => 'nofollow'
		end
		imgpath = "/images/sprites/user_#{icon}.png"
		if FileTest.exists?("#{RAILS_ROOT}/public#{imgpath}")
			img = image_tag(imgpath)
			if i.profile_url
				img = link_to img, i.profile_url, :rel => 'nofollow'
			end
			text = img + text
		end
		content_tag(:span, text, :class => 'userhtml')
	end

	def ident_select(f,identities)
		f.select :identity, identities.collect { |i| [i.icon_and_text[1],i.id] }
	end
end
