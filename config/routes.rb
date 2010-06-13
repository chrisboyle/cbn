ActionController::Routing::Routes.draw do |map|
	map.root          :controller => :posts, :action => :index, :is_root => true, :conditions => {:method => :get}
	map.resources     :posts, :except => :index, :member_path => ':year/:month/:name', :member_path_requirements => {:year => /\d{4}/, :month => /\d{2}/} do |p|
	map.month         ':year/:month', :controller => :posts, :action => :index, :requirements => {:year => /\d{4}/, :month => /\d{2}/}, :conditions => {:method => :get}
	map.month         ':year', :controller => :posts, :action => :index, :requirements => {:year => /\d{4}/}, :conditions => {:method => :get}
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

	map.redirect      'blog', '/'
	map.redirect      'journal', '/'
	map.redirect      'rss', '/feed'
	map.redirect      '3yp', '/projects/c4'
	map.redirect      'amazon', 'https://www.amazon.co.uk/gp/pdp/profile/A14ZX1C5G75VLP?ie=UTF8'
	map.redirect      'calendar', 'http://www.google.com/calendar/embed?src=chris.boyle.name%40gmail.com&ctz=Europe/London'
	map.redirect      'comics', 'http://www.google.com/reader/shared/user/17429808451195384076/label/comics'
	map.redirect      'ebay', 'http://feedback.ebay.com/ws/eBayISAPI.dll?ViewFeedback&userid=chrisboyle'
	map.redirect      'facebook', 'http://www.facebook.com/shortcipher'
	map.redirect      'insanejournal', 'http://shortcipher.insanejournal.com/86249.html'
	map.redirect      'lastfm', 'http://last.fm/user/shortcipher'
	map.redirect      'linkedin', 'http://www.linkedin.com/in/shortcipher'
	map.redirect      'livejournal', 'http://shortcipher.livejournal.com/71821.html'
	map.redirect      'photos', 'http://picasaweb.google.com/chris.boyle.name'
	map.redirect      'picasa', 'http://picasaweb.google.com/chris.boyle.name'
	map.redirect      'steam', 'http://steamcommunity.com/id/kerneloops'
	map.redirect      'twitter', 'http://twitter.com/c_boyle'
	map.redirect      'wishlist', 'http://www.amazon.co.uk/gp/registry/wishlist/RC97AUMCBBGA?reveal=unpurchased&filter=all&sort=priority&layout=standard'
	map.redirect      'xmms-arts', 'http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=456745'

	map.resources     :static_pages, :except => :index, :member_path => ':name'
end
