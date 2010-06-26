# encoding: UTF-8
require 'apis/wp_api'

class WPService < ActionWebService::Base
	web_service_api WPAPI

	def getUsersBlogs(user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		[Blog::Blog.new(
			:url => controller.root_url,
			:xmlrpc => controller.xmlrpc_api_url(:secure=>Rails.env.production? ? true : nil),
			:blogid => 1,
			:blogName => SITE_NAME
		)]
	end

	def getComments(blog_id, user, pw, struct)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		p = struct['post_id']
		return [] if p.to_i < 0
		(p.present? ? Post.find(p).comments : Comment).find_all_by_deleted(false).collect do |c|
			Blog::Comment.new(
				:dateCreated => c.created_at,
				:date_created_gmt => c.created_at.dup.utc,
				:user_id => c.user.id,
				:comment_id => c.id,
				:parent => c.parent ? c.parent.id : '',
				:status => c.approved ? 'approve' : 'hold',
				:content => c.body,
				:link => controller.url_for(c),
				:post_id => c.post.id,
				:post_title => c.post.title,
				:author => c.identity.icon_and_text[1],
				:author_url => c.identity.url || '',
				:author_email => c.user.email || '',
				:author_ip => c.created_ip
			)
		end
	end

	def newComment(blog_id, user, pw, post_id, struct)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		Comment.create! do |c|
			c.post_id = post_id
			c.identity_id = Role.find_by_name('admin').users.first.identity_id  # TODO?
			c.parent_id = struct['comment_parent']
			c.body = struct['content']
			c.created_ip = c.updated_ip = controller.request.remote_ip
			c.approved = true
		end.id
	end

	def editComment(blog_id, user, pw, comment_id, struct)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		c = Comment.find_by_id(comment_id)
		c.approved = (struct['status']=='approve')
		# We deliberately don't support editing date/author/content
		c.save!
	end

	def deleteComment(blog_id, user, pw, comment_id)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		c = Comment.find_by_id(comment_id)
		c.deleted = true
		# We deliberately don't support really deleting/purging over XMLRPC
		c.save!
	end

	def getCategories(blog_id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		[]  # we don't do those
	end

	def getPageList(blog_id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		StaticPage.all.collect do |p|
			Blog::PageListEntry.new(
				:page_id => -1 * p.id,  # ugly hack because WP assumes Post/Page ids are the same namespace
				:page_title => p.title,
				:page_parent_id => 0,
				:dateCreated => p.created_at ? p.created_at.dup.utc : Time.now.utc
			)
		end
	end

	def getPage(blog_id, page_id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		page_as_wp_struct(StaticPage.find(-1 * page_id))  # aforementioned ugly hack
	end

	def getPage(blog_id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		StaticPage.all.collect {|p| page_as_wp_struct(p) }
	end

	def deletePage(blog_id, user, pw, page_id)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		StaticPage.destroy(-1 * page_id)  # aforementioned ugly hack
		true
	end

	protected

	def page_as_wp_struct(p)
		u = Thread.current[:xmlrpc_controller].url_for(p)
		Blog::Page.new(
			:dateCreated => p.created_at ? p.created_at.dup.utc : Time.now.utc,
			:date_created_gmt => p.created_at ? p.created_at.dup.utc : Time.now.utc,
			:userid => 1,
			:page_id => -1*p.id,  # aforementioned ugly hack
			:page_status => 'publish',
			:description => p.body,
			:title => p.title,
			:link => u,
			:permaLink => u,
			:categories => [],
			:excerpt => '',
			:text_more => '',
			:mt_allow_comments => true,
			:mt_allow_pings => false,
			:wp_slug => p.name,
			:wp_password => '',
			:wp_author => AUTHOR_NAME,
			:wp_page_parent_id => 0,
			:wp_page_parent_title => '',
			:wp_page_order => 0,
			:wp_author_id => 1,
			:wp_author_display_name => AUTHOR_NAME,
			:custom_fields => [],
			:wp_page_template => ''
		)
	end
end
