ActionController::Routing::Routes.draw do |map|
	map.root          :controller => :posts, :action => :index, :is_root => true, :conditions => {:method => :get}
	map.resources     :posts, :except => :index, :member_path => ':year/:month/:name', :member_path_requirements => {:year => /\d{4}/, :month => /\d{2}/} do |p|
		p.resources   :comments, :only => [:index,:create,:new]
	end
	map.feed          'feed', :controller => :posts, :action => :index, :format => 'atom', :conditions => {:method => :get}
	map.resources     :users, :except => [:new,:create,:edit] do |u|
		u.resources   :comments, :only => :index
		u.connect     'comments', :conditions => {:method => :delete}, :controller => :users, :action => 'delete_comments'
	end
	map.resource      :user_sessions, :as => 'session', :except => [:edit,:update]
	map.connect       'logout', :controller => :user_sessions, :action => :destroy
	map.resources     :comments, :except => [:new,:create], :member => {:reply => :get, :approve => :post, :trust => :post, :disapprove => :post}
	map.resources     :projects
	map.resources     :acts_as_taggable_on_tags, :as => :tags, :only => [:index,:show], :controller => :tags
	map.resources     :static_pages, :except => :index, :member_path => ':name'
end
