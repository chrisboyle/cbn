class Mailer < ActionMailer::Base
	include ActionView::Helpers::TextHelper

	def reply(comment, to, link)
		from MAIL_FROM
		bcc BCC
		recipients to
		subject "New comment on chris.boyle.name: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}"
		body :comment => comment, :link => link
	end

	def moderator(comment, to, link)
		from MAIL_FROM
		#bcc BCC
		recipients to
		subject "Moderation required on chris.boyle.name: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}"
		body :comment => comment, :link => link
	end

	def post(post, to, link)
		from MAIL_FROM
		bcc BCC
		recipients to
		subject "New post on chris.boyle.name: #{post.title}"
		body :post => post, :link => link
	end

	def edit(post, to, link)
		from MAIL_FROM
		bcc BCC
		recipients to
		subject "Changes to a post on chris.boyle.name: #{post.title}"
		body :post => post, :link => link
	end
end
