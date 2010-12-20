# encoding: UTF-8
require 'apis/blogger_api'

class BloggerService < ActionWebService::Base
	web_service_api BloggerAPI

	def getRecentPosts(key, id, user, pw, limit)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		Post.all(:order => 'created_at DESC', :limit=>limit).collect do |p|
			post_as_blogger_struct(p)
		end
	end

	def getPost(key, id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		post_as_blogger_struct(Post.find(id))
	end

	def editPost(key, post_id, user, pw, content, publish)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		p = Post.find_by_id(post_id)
		p.body = content
		if not p.draft and publish then p.created_at = p.updated_at = Time.now end
		p.draft = ! publish
		p.save!
	end

	def deletePost(key, post_id, user, pw, publish)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		if post_id.to_i < 0 then StaticPage.destroy(-1 * post_id) else Post.destroy(post_id) end
		true
	end

	def getUsersBlogs(key, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		[Blog::Blog.new(
			:url => controller.root_url,
			:blogid => 1,
			:blogName => SITE_NAME
		)]
	end

	def getUserInfo(key, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		Blog::User.new(:nickname => user, :email => Role.find_by_name('admin').users.first.email)
	end

	protected

	def post_as_blogger_struct(p)
		u = Thread.current[:xmlrpc_controller].url_for(p)
		Blog::Post.new(
			:postid => p.id,
			:link => u,
			:permaLink => u,
			:userid => 1,  # we don't have multiple authors
			:title  => p.title,
			:description => p.body,
			:content => "<title>%s</title>%s" % [p.title,p.body],
			:dateCreated => p.created_at.dup.utc,
			:mt_keywords => p.tag_list
		)
	end
end
