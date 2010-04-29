class Identity < ActiveRecord::Base
	belongs_to :user

	def icon_and_text
		@icon_and_text ||= case provider
		when 'facebook','twitter' then [provider, display_name]
		when 'openid' then case identifier
			when /^https?:\/\/([^.]+)\.livejournal\.com\/$/ then ['livejournal', $1]
			when /^https?:\/\/([^.]+)\.insanejournal\.com\/$/ then ['insanejournal', $1]
			when /^https?:\/\/([^.]+)\.dreamwidth\.org\/$/ then ['dreamwidth', $1]
			when /^https?:\/\/(?:www\.)?google\.com\/accounts\/o8\/id\?id=(.*)/ then ['google', display_name || $1]
			else ['openid',sub(/^https?:\/\//,'').sub(/\/$/,'')]
			end
		else [nil,display_name]
		end
	end
end
