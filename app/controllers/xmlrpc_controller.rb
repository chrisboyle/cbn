require 'apis/meta_weblog_service'
require 'apis/blogger_service'
require 'apis/wp_service'

class XmlrpcController < ApplicationController
	acts_as_web_service
	web_service_dispatching_mode :layered
	before_filter do |c|
		Thread.current[:xmlrpc_controller] = c
	end

	web_service :metaWeblog, MetaWeblogService.new
	web_service :blogger, BloggerService.new
	web_service :wp, WPService.new

	def auth(u, p)
		raise Authorization::AuthorizationError unless (XMLRPC_AUTH['username'] and XMLRPC_AUTH['password'] and u==XMLRPC_AUTH['username'] and p==XMLRPC_AUTH['password'])
	end
end
