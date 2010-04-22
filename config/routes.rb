ActionController::Routing::Routes.draw do |map|
	map.connect       '', :controller => :pages, :action => :create, :conditions => {:method => :post}
	map.resources     :posts, :member_path => ':year/:month/:name', :member_path_requirements => {:year => /\d{4}/, :month => /\d{2}/}, :has_many => :comments
	map.pages         '', :controller => :pages, :action => :index, :is_root => true, :conditions => {:method => :get}
	map.feed          'feed.:format', :controller => :pages, :action => :index, :conditions => {:method => :get}
	map.resources :users
	map.resource :user_sessions, :as => 'session', :except => [:edit,:update]
	map.connect       'logout', :controller => :user_sessions, :action => :destroy
	map.new_page      'newpage.:format', :controller => :pages, :action => :new, :conditions => {:method => :get}
	map.static_page   ':name.:format', :controller => :pages, :action => :show, :conditions => {:method => :get}
	map.connect       ':name.:format', :controller => :pages, :action => :update, :conditions => {:method => :put}
	map.connect       ':name.:format', :controller => :pages, :action => :destroy, :conditions => {:method => :delete}
	map.edit_static_page ':name/edit.:format', :controller => :pages, :action => :edit, :conditions => {:method => :get}
	map.static_page_comments ':name/comments.:format', :controller => 'comments', :action => 'index', :conditions => {:method => :get}
	map.connect       ':name/comments.:format', :controller => 'comments', :action => 'create', :conditions => {:method => :post}
end
