resources :dispatches, :only => [] do
  get 'read', 'unsubscribe', :on => :member
  resources :links, :controller => :dispatch_links, :only => [:show]
end