resources :dispatches do
  get :queue, :chart_data, :opens, :clicks, :unsubscribes, :on => :member
  patch :test_send, :send_all, :on => :member
  resources :links, :controller => :dispatch_links, :only => [:index]
  resources :opens, :controller => :dispatch_opens, :only => [:index]
end
