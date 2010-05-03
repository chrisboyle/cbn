module IdentitiesHelper
	def ident_html(i, html=true)
		icon, text = *i.icon_and_text
		if html and i.url
			text = link_to text, i.url, :rel => 'nofollow'
		end
		imgpath = "/images/sprites/user_#{icon}.png"
		if FileTest.exists?("#{RAILS_ROOT}/public#{imgpath}")
			img = image_tag(imgpath)
			if html and i.profile_url
				img = link_to img, i.profile_url, :rel => 'nofollow'
			end
			text = img + text
		end
		content_tag(:span, text, :class => 'userhtml')
	end

	def ident_select(f,identities)
		if identities.count == 1
			ident_html(identities.first) + f.hidden_field(:identity_id)
		else
			f.select :identity_id, identities.collect { |i| ["[#{i.icon_and_text[0]}] #{i.icon_and_text[1]}",i.id] }
		end
	end
end
