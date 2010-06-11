class Mailer < ActionMailer::Base
	include ActionView::Helpers::TextHelper
	default :from => MAIL_FROM, :bcc => BCC

	def reply(comment, to, link)
		@comment = comment
		@link = link
		mail(:to => to,
			 :subject => "New comment on #{EMAIL_SITE_NAME}: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}")
	end

	def moderator(comment, to, link)
		@comment = comment
		@link = link
		mail(:to => to, :bcc => nil,
			:subject => "Moderation required on #{EMAIL_SITE_NAME}: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}")
	end

	def post(post, to, link)
		@post = post
		@link = link
		mail(:to => to,
			:subject => "New post on #{EMAIL_SITE_NAME}: #{post.title}")
	end

	def edit(post, to, link)
		@post = post
		@link = link
		mail(:to => to,
			:subject => "Changes to a post on #{EMAIL_SITE_NAME}: #{post.title}")
	end
end
