module UserSessionsHelper
	def login_button_content(name)
		image_tag("/images/sprites/fav_#{name.downcase}.png") + content_tag(:span,' '+name)
	end
	def login_button_action(name, url)
		update_page do |page|
			t = page[:user_session_openid_identifier]
			if name == 'Facebook'
				page.call 'FB.Connect.requireSession' do |p|
					page[:auth_using_fb].value = 1
					page[:user_session_submit].click
				end
			elsif name == 'Twitter'
				page[:login_with_oauth].value = 1
				page[:user_session_submit].click
			else
				t.value = url
				if /username/.match url
					page.call 'selectTextField', :user_session_openid_identifier, $~.offset(0)
				else
					page[:user_session_submit].click
				end
			end
		end
	end
end
