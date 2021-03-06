Sanmgmtappl::Application.routes.draw do

  match "san_communications/call/:id/:method" => "san_communications#call"

  post "zone/create"

  match "zone/remove/:id" => "zone#remove"

  get "zone/new"

  get "zone/show"

  match "zone/edit/:id" => "zone#edit"
  
  match "zone/update/:id" => "zone#update"

  get "storage/show"

  match "storage/remove/:id" => "storage#remove"

  get "server/show"

  match "server/remove/:id" => "server#remove"

  post "switch/create"

  match "switch/remove/:id" => "switch#remove"

  get "switch/new"

  get "switch/show"
  
  match "switch/edit/:id" => "switch#edit"
  
  match "switch/update/:id" => "switch#update"

  get "xml/generate"
  
  match "xml/update" => "xml#update"

  get "user/settings"

  post "user/changepassword"

  post "login/create"

  get "login/destroy"

  get "main/login"

  get "main/index"
  
  root :to => "main#login"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
