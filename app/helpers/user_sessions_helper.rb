module UserSessionsHelper
	def loginbutton(name, url)
		content_tag :button, image_tag("/images/sprites/fav_#{name.downcase}.png")+content_tag(:span,' '+name), {:class => 'loginbutton', :onclick => update_page do |page|
			s = page[:user_session_submit]
			tid = :user_session_openid_identifier
			t = page[tid]
			if name == 'Facebook'
				page.call 'FB.Connect.requireSession' do |p|
					page[:auth_using_fb].value = 1
					s.click
				end
			elsif name == 'Twitter'
				page.call 'GoGoGadgetTwitter'
			else
				t.value = url
				if /username/.match url
					page.call 'selectTextField', tid, $~.offset(0)
				else
					s.click
				end
			end
		end}
	end
end
