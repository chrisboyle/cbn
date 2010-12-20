# encoding: UTF-8
require 'apis/meta_weblog_api'

class MetaWeblogService < ActionWebService::Base
	web_service_api MetaWeblogAPI

	def newPost(id, user, pw, struct, publish)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		p = struct['post_type']=='page' ? StaticPage.new : Post.new
		# TODO put slug generation somewhere sensible
		p.name = struct['title'].downcase.gsub(/[^a-z0-9_-]+/,'-').sub(/^-+/,'').sub(/-+$/,'')
		p.title = struct['title']
		p.body = struct['description']
		if p.respond_to?(:tag_list) then p.tag_list = struct['mt_keywords'] end
		p.draft = ! publish
		p.save!
		p.id
	end

	def editPost(post_id, user, pw, struct, publish)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		p = (post_id.to_i < 0) ? StaticPage.find(-1 * post_id.to_i) : Post.find(post_id)
		p.title = struct['title']
		p.body = struct['description']
		if p.respond_to?(:tag_list) then p.tag_list = struct['mt_keywords'] end
		if not p.draft and publish then p.created_at = p.updated_at = Time.now end
		p.draft = ! publish
		p.save!
	end

	def getPost(post_id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		post_as_mw_struct((post_id.to_i < 0) ? StaticPage.find(-1 * post_id.to_i) : Post.find(post_id))
	end

	def getCategories(id, user, pw)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		[]  # we don't do those
	end

	def getRecentPosts(id, user, pw, num)
		controller = Thread.current[:xmlrpc_controller]
		controller.auth(user,pw)
		Post.all(:order => 'created_at DESC', :limit=>limit).collect do |p|
			post_as_mw_struct(p)
		end
	end

	protected

	def post_as_mw_struct(p)
		u = Thread.current[:xmlrpc_controller].url_for(p)
		Blog::Post.new(
			:postid => p.id,
			:link => u,
			:permaLink => u,
			:userid => 1,  # we don't have multiple authors
			:title  => p.title,
			:description => p.body,
			:content => "<title>%s</title>%s" % [p.title,p.body],
			:mt_text_more => '',
			:dateCreated => p.created_at ? p.created_at.dup.utc : Time.now.utc,
			:mt_keywords => (p.respond_to? :tag_list) ? tag_list : '',
			:post_status => if p.draft then 'draft' else 'publish' end
		)
	end
end
