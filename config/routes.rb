ActionController::Routing::Routes.draw do |map|
	map.pages '', :controller => :pages, :action => :index, :is_root => true, :conditions => {:method => :get}
	map.page ':year/:month/:name.:format', :controller => 'pages', :action => 'show', :year => /\d{4}/, :month => /\d{2}/, :conditions => {:method => :get}
	map.connect ':year/:month/:name.:format', :controller => 'pages', :action => 'update', :year => /\d{4}/, :month => /\d{2}/, :conditions => {:method => :put}
	map.connect ':year/:month/:name.:format', :controller => 'pages', :action => 'destroy', :year => /\d{4}/, :month => /\d{2}/, :conditions => {:method => :delete}
	map.edit_page ':year/:month/:name/edit.:format', :controller => 'pages', :action => 'edit', :year => /\d{4}/, :month => /\d{2}/, :conditions => {:method => :get}
	map.new_page 'newpage.:format', :controller => :pages, :action => :new, :conditions => {:method => :get}

	map.page_comments ':year/:month/:name/comments.:format', :controller => 'comments', :action => 'index', :year => /\d{4}/, :month => /\d{2}/, :conditions => {:method => :get}
	map.connect ':year/:month/:name/comments.:format', :controller => 'comments', :action => 'create', :year => /\d{4}/, :month => /\d{2}/, :conditions => {:method => :post}

	map.feed 'feed.:format', :controller => :pages, :action => :index, :conditions => {:method => :get}

	map.resource :session
end
