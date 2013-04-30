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