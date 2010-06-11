module UserSessionsHelper
	def login_button_action(site, url)
		return nil if site=='Twitter'
		update_page do |page|
			if site == 'Facebook'
				page.call 'FB.Connect.requireSession' do |p|
					p[:login_with_hidden].name = 'login_with_facebook'
					p[:login_with_hidden].value = 1
					p[:new_user_session].submit
				end
				page << 'return false'
			else
				page[:user_session_openid_identifier].value = url
				if /username/.match url
					page.call 'selectTextField', :user_session_openid_identifier, $~.offset(0)
					page << 'return false'
				end
			end
		end
	end

	def login_button(site, url)
		name = "login_with_#{site=='Twitter' ? 'oauth' : site.downcase}"
		attrs = {:id => name, :name => name, :value => 1, :onclick => login_button_action(site, url)}
		attrs.merge!({:disabled => true, :title => 'Facebook requires JavaScript'}) if site=='Facebook'
		content_tag(:button, image_tag("/images/sprites/fav_#{site.downcase}.png") + content_tag(:span,' '+site), attrs) + (site=='Facebook' ? javascript_tag("document.getElementById('login_with_facebook').title = 'Loading Javascript...';") : '')
	end
end
