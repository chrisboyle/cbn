class Identity < ActiveRecord::Base
	belongs_to :user
	has_many :comments

	def icon_and_text
		@icon_and_text ||= case provider
		when 'facebook','twitter' then [provider, display_name]
		when 'openid' then case identifier
			when /^https?:\/\/users\.((?:liv|insan)ejournal)\.com\/([^\/\?]+)$/ then [$1, $2]
			when /^https?:\/\/([^.\/]+)\.((?:liv|insan)ejournal)\.com\/$/ then [$2, $1]
			when /^https?:\/\/([^.\/]+)\.(dreamwidth)\.org\/$/ then [$2, $1]
			when /^https?:\/\/(?:www\.)?google\.com\/accounts\/o8\/id\?id=(.*)/ then ['google', display_name || $1]
			when /^https?:\/\/me\.yahoo\.com\/(?:a\/)?(.*)/ then ['yahoo', display_name || $1]
			else ['openid',identifier.sub(/^https?:\/\//,'').sub(/\/$/,'')]
			end
		else [nil,display_name]
		end
	end

	def guess_urls
		case provider
		when 'twitter'
			self.url = 'http://twitter.com/'+self.display_name
		when 'openid' then case identifier
			when /^https?:\/\/(users\.(?:live|insane)journal\.com\/[^\/\?]+)$/,
					/^https?:\/\/([^.]+\.(?:(?:live|insane)journal\.com|dreamwidth\.org))\/$/
				self.url = "http://#{$1}/"
				self.profile_url = self.url+'profile'
		end
		end
	end
end
