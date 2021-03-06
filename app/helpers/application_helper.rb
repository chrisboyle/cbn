# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def title(t)
		content_for :title, t
	end

	def description(d)
		d.sub!(/.*<p class='summary'>(.*?)<\/p>.*/m,'\1')  # e.g. CV
		d = strip_tags(d).gsub(/\s+/,' ').gsub(/&quot;/,'"').sub(/^PDF version\s*/,'').strip
		content_for :head, tag('meta', :name=>'description', :content => truncate(d, :length=>DESCRIPTION_LENGTH))
	end

	def titleh1(t)
		title(t)
		content_tag(:h1, t)
	end

	def button_to_act(action, object, js_options = {})
		label = action.to_s.capitalize
		method, act_name = case action
				when :delete      then [:delete,:destroy]
				when :edit,:reply then [:get,action]
				else              [:post,action]
				end
		confirm = js_options.delete(:confirm)
		bits = {:controller => ActionController::RecordIdentifier.plural_class_name(object),
					  :action => act_name, :id => object}
		url, jsurl = url_for(bits), url_for(bits.merge(js_options))
		form_remote_tag :url => jsurl, :html => {:action => url, :method => method},
				:method => method, :confirm => confirm do
			concat(content_tag :button, label, :type => :submit)
		end
	end

	def tag_path(t)
		acts_as_taggable_on_tag_path(t)
	end
end

class Time
	def friendly8601
		strftime('%Y-%m-%d %H:%M:%S')
	end

	TIMESTAMP_RX = Regexp.compile /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/
	def self.from_timestamp(ts)
		m = TIMESTAMP_RX.match(ts)
		return nil unless m
		zone.local(*(m[1..6].map &:to_i))
	end
end
