Testapp::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "sessions#destroy"
    get "/register" => "devise/registrations#new"
  end
  resources :comments, :only => [:create, :destroy]
  
  namespace :forge do
    resources :assets do
      get 'drawer', :on => :collection
      get 'place', 'prepare', :on => :member
      post 'encode_notify', :on => :collection
    end
    
    resources :users, :except => [:show] do
      get 'approve', :on => :member
    end
    
    resource :settings, :only => [:show, :update]
    
    #resources :help_topics, :only => [:index, :show]
    match "help", :controller => :help_topics, :action => :index
    match "help/search", :controller => :help_topics, :action => :search
    match "help/:slug", :controller => :help_topics, :action => :show
    
    root :to => "index#index"
  end
  
  match "/sitemap", :controller => 'index', :action => 'sitemap'
  root :to => "index#index"
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
  # match ':controller(/:action(/:id))(.:format)'
end
