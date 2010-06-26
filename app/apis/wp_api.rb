# encoding: UTF-8
#
# see the WordPress API spec at http://codex.wordpress.org/XML-RPC_wp
#

module Blog
	class Blog < ActionWebService::Struct
		member :url,      :string
		member :xmlrpc,   :string
		member :blogid,   :string
		member :blogName, :string
	end

	class User < ActionWebService::Struct
		member :nickname,  :string
		member :userid,    :string
		member :url,       :string
		member :email,     :string
		member :lastname,  :string
		member :firstname, :string
	end

	class Comment < ActionWebService::Struct
		member :dateCreated, :datetime
		member :date_created_gmt, :datetime
		member :user_id,     :string
		member :comment_id,  :string
		member :parent,      :string
		member :status,      :string
		member :content,     :string
		member :link,        :string
		member :post_id,     :string
		member :post_title,  :string
		member :author,      :string
		member :author_url,  :string
		member :author_email,:string
		member :author_ip,   :string
	end

	class Category < ActionWebService::Struct
		member :categoryId, :int
		member :parentId, :int
		member :description, :string
		member :categoryName, :string
		member :htmlUrl, :string
		member :rssUrl, :string
	end

	class GetComments < ActionWebService::Struct
		member :post_id, :string
		member :status,  :string
		member :offset,  :string
		member :number,  :string
	end

	class NewComment < ActionWebService::Struct
		member :comment_parent, :int
		member :content, :string
		member :author, :string
		member :author_url, :string
		member :author_email, :string
	end

	class EditComment < ActionWebService::Struct
		member :status, :string
		member :date_created_gmt, :string
		member :content, :string
		member :author, :string
		member :author_url, :string
		member :author_email, :string
	end

	class PageListEntry < ActionWebService::Struct
		member :page_id, :int
		member :page_title, :string
		member :page_parent_id, :int
		member :dateCreated, :datetime
	end

	class CustomField < ActionWebService::Struct
		member :id, :string
		member :key, :string
		member :value, :string
	end

	class Page < ActionWebService::Struct
		member :dateCreated, :datetime
		member :userid, :int
		member :page_status, :string
		member :description, :string
		member :title, :string
		member :link, :string
		member :permaLink, :string
		member :categories, [Category]
		member :excerpt, :string
		member :text_more, :string
		member :mt_allow_comments, :int
		member :mt_allow_pings, :int
		member :wp_slug, :string
		member :wp_password, :string
		member :wp_author, :string
		member :wp_page_parent_id, :int
		member :wp_page_parent_title, :string
		member :wp_page_order, :int
		member :wp_author_id, :int
		member :wp_author_display_name, :string
		member :date_created_gmt, :datetime
		member :custom_fields, [CustomField]
		member :wp_page_template, :string
		member :page_id, :int
		member :page_title, :string
	end
end

class WPAPI < ActionWebService::API::Base
	inflect_names false

	api_method :getUsersBlogs, :returns => [[Blog::Blog]], :expects => [
		{:username=>:string},
		{:password=>:string}
	]

	api_method :getComments, :returns => [[Blog::Comment]], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string},
		{:struct=>Blog::GetComments}
	]

	api_method :newComment, :returns => [:int], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string},
		{:post_id=>:int},
		{:struct=>Blog::NewComment}
	]

	api_method :editComment, :returns => [:bool], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string},
		{:comment_id=>:int},
		{:struct=>Blog::EditComment}
	]

	api_method :deleteComment, :returns => [:bool], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string},
		{:comment_id=>:int}
	]

	api_method :getCategories, :returns => [[Blog::Category]], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string}
	]

	api_method :getPageList, :returns => [[Blog::PageListEntry]], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string}
	]

	api_method :getPage, :returns => [Blog::Page], :expects => [
		{:blog_id=>:int},
		{:page_id=>:int},
		{:username=>:string},
		{:password=>:string}
	]

	api_method :getPages, :returns => [[Blog::Page]], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string}
	]

	api_method :deletePage, :returns => [:bool], :expects => [
		{:blog_id=>:int},
		{:username=>:string},
		{:password=>:string},
		{:page_id=>:int}
	]
end
