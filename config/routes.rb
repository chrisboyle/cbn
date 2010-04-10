ActionController::Routing::Routes.draw do |map|
  #map.resources :pages, :as => 'blog', :has_many => :comments
  map.page ':year/:month/:name.:format', :controller => 'pages', :action => 'find_by_month_and_name', :requirements => { :year => /\d{4}/, :month => /\d{2}/ }
  map.new_page 'pages/new', :controller => :pages, :action => :new
  #map.edit_page ':year/:month/:name/edit', :controller => 'pages', :action => 'edit_by_month_and_name', :requirements => { :year => /\d{4}/, :month => /\d{2}/ }
  map.edit_page 'pages/:id/edit', :controller => :pages, :action => :edit
  map.pages '', :controller => :pages, :action => :index, :is_root => true
  map.feed 'feed.:format', :controller => :pages, :action => :index, :is_root => true
  map.resource :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"
end
