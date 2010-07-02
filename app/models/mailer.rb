class Mailer < ActionMailer::Base
	include ActionView::Helpers::TextHelper

	def reply(comment, to, link, unsub)
		from MAIL_FROM
		bcc BCC
		recipients to
		subject "New comment on #{EMAIL_SITE_NAME}: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}"
		body :comment => comment, :link => link, :unsub => unsub
	end

	def moderator(comment, to, link)
		from MAIL_FROM
		#bcc BCC
		recipients to
		subject "Moderation required on #{EMAIL_SITE_NAME}: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}"
		body :comment => comment, :link => link
	end

	def post(post, to, link, unsub)
		from MAIL_FROM
		bcc BCC
		recipients to
		subject "New post on #{EMAIL_SITE_NAME}: #{post.title}"
		body :post => post, :link => link, :unsub => unsub
	end

	def edit(post, to, link, unsub)
		from MAIL_FROM
		bcc BCC
		recipients to
		subject "Changes to a post on #{EMAIL_SITE_NAME}: #{post.title}"
		body :post => post, :link => link, :unsub => unsub
	end

	def signup_admin(user, to, link)
		from MAIL_FROM
		#bcc BCC
		recipients to
		it = user.identity.icon_and_text
		t = "[#{it[0]}] #{it[1]}"
		subject "New user on #{EMAIL_SITE_NAME}: #{truncate(t, :length => 40)}"
		body :user => user, :link => link
	end

	def comment_admin(comment, to, link, is_edit)
		from MAIL_FROM
		#bcc BCC
		recipients to
		subject "#{is_edit ? 'Edited' : 'New'} comment on #{EMAIL_SITE_NAME}: #{truncate(comment.body.gsub(/\n+/,'  '), :length => 40)}"
		body :comment => comment, :link => link, :is_edit => is_edit
	end
end
