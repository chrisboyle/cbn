Cbn::Application.routes.draw do |map|
	root :to => 'pages#index', :via => :get, :is_root => true
	resources :pages, :only => [:new,:create]
	resources :posts, :controller => :pages, :except => [:index,:create,:new], :member_path => ':year/:month/:name', :member_path_requirements => {:year => /\d{4}/, :month => /\d{2}/} do
		resources :comments, :only => [:index,:create,:new]
	end
	get '/feed' => 'pages#index', :format => 'atom'
	resources :users, :except => [:new,:create,:edit] do
		resources :comments, :only => :index
		resources :comments, :only => :delete, :controller => :users, :action => :delete_comments
	end
	resource :session, :as => :user_session, :controller => :user_sessions, :except => [:edit,:update]
	match '/logout' => 'user_sessions#destroy'
	resources :comments, :except => [:new,:create] do
		member do
			get :reply
			post :approve
			post :trust
			post :disapprove
		end
	end
	resources :projects
	resources :acts_as_taggable_on_tags, :as => :tags, :only => [:index,:show], :controller => :tags
	resources :static_pages, :controller => :pages, :except => [:index,:create,:new], :member_path => ':name'
end
