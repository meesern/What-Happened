ActionController::Routing::Routes.draw do |map|
  map.resources :replays

  map.site_search  'search', :controller => 'front', :action => 'search'
  map.root :controller => 'front', :action => 'index'

  Hobo.add_routes(map)

  #Data interface
  #  JSON
  map.connect 'v1/file_a_report/:aspect', :controller => 'api', :action => 'file_json', :method => 'post'
  map.connect 'v1/data/:aspect', :controller => 'api', :action => 'data_json'

  #  XML
  map.connect 'v1/xml/file_a_report/:aspect', :controller => 'api', :action => 'file_xml', :method => 'post'
  map.connect 'v1/xml/data/:aspect', :controller => 'api', :action => 'data_xml'

  #Counts interface
  #  JSON
  map.connect 'v1/counts/:aspect/:year/:day/:minute', :controller => 'api', :action => 'counts_json'
  map.connect 'v1/counts/:aspect/:year/:day', :controller => 'api', :action => 'counts_json'
  map.connect 'v1/counts/:aspect/:year', :controller => 'api', :action => 'counts_json'
  map.connect 'v1/counts/:aspect', :controller => 'api', :action => 'counts_json'

  #  XML
  map.connect 'v1/xml/counts/:aspect/:year/:day/:minute', :controller => 'api', :action => 'counts_xml'
  map.connect 'v1/xml/counts/:aspect/:year/:day', :controller => 'api', :action => 'counts_xml'
  map.connect 'v1/xml/counts/:aspect/:year', :controller => 'api', :action => 'counts_xml'
  map.connect 'v1/xml/counts/:aspect', :controller => 'api', :action => 'counts_xml'

  #Properties interface
  #  JSON
  map.connect 'v1/entity_property/:id', :controller => 'api', :action => 'file_entity_property', :method => 'post'
  map.connect 'v1/item_property/:id', :controller => 'api', :action => 'file_item_property', :method => 'post'
  map.connect 'v1/properties', :controller => 'api', :action => 'query'
  map.connect 'v1/properties', :controller => 'api', :action => 'query', :method => 'post'
  map.connect 'v1/delete_property/:id', :controller => 'api', :action => 'delete_property'

  #items interface
  #  JSON
  map.connect 'v1/items/',       :controller => 'api',   :action => 'apiindex_json', :method => 'get'
  map.connect 'v1/items/:id',  :controller => 'api',   :action => 'apicreate_json', :method => 'post'

  #  XML
  map.connect 'v1/xml/items/',       :controller => 'api',   :action => 'apiindex_xml', :method => 'get'
  map.connect 'v1/xml/items/:id',  :controller => 'api',   :action => 'apicreate_xml', :method => 'post'
  
  #replay interface
  map.connect 'v1/replay-create/:aspect',     :controller => 'replays',   :action => 'create', :method => 'post'
  map.connect 'v1/replay-control/:replay',  :controller => 'replays',   :action => 'control', :method => 'post'

  #Exception logger
  map.connect "logged_exceptions/:action/:id/", :controller=> 'logged_exceptions'

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

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
