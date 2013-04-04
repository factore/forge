Forge3::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions" }
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "sessions#destroy"
    get "/register" => "devise/registrations#new"
  end

  # SHOPPING & E-ECOMMERCE - FRONT END
  # ==================================

  # Order routes
  # ------------
  # new & create: not used, orders are created automatically when user commences shopping.
  # edit & update: refers to the contents of the order (the line items)
  # checkout: let's the user view their order, make any changes as needed before paying

  # Line item routes
  # ----------------
  # These belong to orders and are handled as additions or removals from orders, as such, they don't
  # really need all of the standard views and actions.
  resources :products, :only => [:index, :show] do
    collection do
      get :preview
    end
  end

  resources :addresses, :except => [:index, :show, :destroy]
  resources :orders, :only => [:update] do
    member do
      delete 'remove_from_cart'
      get 'paid'
    end
    collection do
      post 'add_to_cart'
      get 'cancel', 'get_cart'
    end
  end

  match 'orders/checkout' => 'orders#checkout_get', :via => :get
  match 'orders/checkout' => 'orders#checkout_post', :via => :post

  get "integrated_payment/billing"
  post "integrated_payment/pay"
  get "hosted_payment/billing"
  post "hosted_payment/notify"

  # END SHOPPING & E-ECOMMERCE - FRONT END
  # ======================================

  resources :countries, :only => [] do
    member do
      get 'get_provinces_for_checkout'
    end
  end

  resources :posts, :only => [:index, :show] do
    collection do
      get :preview, :feed
    end
    member do
      get :category
    end
  end
  resources :comments, :only => [:create, :destroy]
  #resources :galleries # we don't seem to have a galleries controller

  resources :events, :only => [:index, :show]

  if Forge::Settings[:events][:display] == 'calendar'
    match 'events/:year/:month' => 'events#index', :via => :get
  end

  resources :dispatches, :only => [] do
    get 'read', 'unsubscribe', :on => :member
    resources :links, :controller => :dispatch_links, :only => [:show]
  end

  resources :contact, :only => :index do
    post     'submit', :on => :collection
  end

  namespace :forge do
    resources :pages do
      post    'reorder', :on => :collection
    end

    resources :posts
    resources :post_categories, :except => [:show, :new]
    resources :comments, :only => [:index, :destroy] do
     put     'approve', :on => :member
     put     'unapprove', :on => :member
    end

    resources :events, :except => [:show]

    resources :banners, :except => [:show] do
      post    'reorder', :on => :collection
    end

    resources :galleries, :except => [:show] do
      post    'reorder', :on => :collection
    end

    resources :assets do
      get 'drawer', :on => :collection
      get 'place', 'prepare', :on => :member
      post 'encode_notify', :on => :collection
    end

    resources :videos, :except => [:show] do
      get 'play', 'encode', :on => :member
      post 'encode_notify', :on => :collection
    end

    resources :video_feeds, :except => [:show, :destroy] do
      get 'publish', :on => :member
    end

    #########################
    #### eCommerce Stuff ####
    #########################
    resources :products, :except => [:show] do
      post 'reorder', :on => :collection
    end

    resources :product_categories, :except => [:show, :new] do
      post    'reorder', :on => :collection
    end

    resources :orders do
     put     'fulfill', :on => :member
     put     'unfulfill', :on => :member
    end

    resources :sales, :except => [:show] do
      get 'products', :on => :collection
    end

    resources :tax_rates, :except => [:show, :new]

    resources :countries, :only => [:index, :update] do
      member do
        get 'get_provinces'
      end
      collection do
        get 'get_active_countries'
      end
    end
    #############################
    #### End eCommerce Stuff ####
    #############################


    ############################
    #### Forge Press Stuff #####
    ############################
    resources :subscriber_groups, :except => [:show]
    resources :subscribers, :except => [:show] do
      get :export, :on => :collection
    end

    resources :dispatches do
     get :queue, :chart_data, :opens, :clicks, :unsubscribes, :on => :member
     put :test_send, :send_all, :on => :member
     resources :links, :controller => :dispatch_links, :only => [:index]
     resources :opens, :controller => :dispatch_opens, :only => [:index]
    end
    ############################
    ## End Forge Press Stuff ###
    ############################

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

  #See how all your routes lay out with "rake routes"

  #This is a legacy wild controller route that's not recommended for RESTful applications.
  #Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id(.:format)))'

  match 'posts/:month/:year', :controller => 'posts', :action => 'index'
  match '/pages/preview', :controller => 'pages', :action => 'preview'
  match "/sitemap", :controller => 'index', :action => 'sitemap'
  match '*slugs', :controller => 'pages', :action => 'show'
  root :to => "index#index"
end
