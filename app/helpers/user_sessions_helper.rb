module UserSessionsHelper
	def login_button_content(name)
		image_tag("/images/sprites/fav_#{name.downcase}.png") + content_tag(:span,' '+name)
	end
	def login_button_action(name, url)
		update_page do |page|
			if name == 'Facebook'
				page.call 'FB.Connect.requireSession' do |p|
					p[:auth_using_fb].value = 1
					p[:new_user_session].submit
				end
			elsif name == 'Twitter'
				page[:login_with_oauth].value = 1
				page[:new_user_session].submit
			else
				page[:user_session_openid_identifier].value = url
				if /username/.match url
					page.call 'selectTextField', :user_session_openid_identifier, $~.offset(0)
				else
					page[:new_user_session].submit
				end
			end
		end
	end
end
