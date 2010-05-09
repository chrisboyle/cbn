# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def title(t)
		content_for :title, t
	end

	def titleh1(t)
		title(t)
		content_tag(:h1, t)
	end

	def posts_path
		pages_path
	end
	def static_pages_path
		pages_path
	end

	def button_to_act(action, object, js_options = {})
		label = action.to_s.capitalize
		method, act_name = case action
				when :delete then [:delete,:destroy]
				when :edit   then [:get,:edit]
				else              [:post,action]
				end
		bits = {:controller => ActionController::RecordIdentifier.plural_class_name(object),
					  :action => act_name, :id => object}
		url, jsurl = url_for(bits), url_for(bits.merge(js_options))
		form_remote_tag :url => jsurl, :html => {:action => url, :method => method}, :method => method,
			:confirm => (action == :delete ? 'Are you sure you want to delete this?' : nil) do
			concat(content_tag :button, label, :type => :submit)
		end
	end

	def visible_comments(user)
		user.comments.find(:all, :conditions => (has_role? :admin) ? nil : {:deleted => false}, :order => 'updated_at DESC')
	end
end

class Time
	def friendly8601
		strftime('%Y-%m-%d %H:%M:%S')
	end
end
