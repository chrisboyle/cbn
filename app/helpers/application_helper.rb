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

	def button_to_act(action, object)
		label = action.to_s.capitalize
		url = url_for(:controller => ActionController::RecordIdentifier.plural_class_name(object),
					  :action => action.to_s.sub('delete','destroy'), :id => object)
		case action
		when :edit
			concat(button_to label, url, :method => :get)
		else
		form_remote_tag :url => url,
			:html => {:method => (action == :delete ? action : nil)},
			:method => (action == :delete ? action : nil),
			:confirm => (action == :delete ? 'Are you sure you want to delete this?' : nil) do
				concat(content_tag :button, label, :type => :submit)
			end
		end
	end
end

class Time
	def friendly8601
		strftime('%Y-%m-%d %H:%M:%S')
	end
end
