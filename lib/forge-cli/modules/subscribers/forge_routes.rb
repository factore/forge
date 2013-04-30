resources :subscriber_groups, :except => [:show]
resources :subscribers, :except => [:show] do
  get :export, :on => :collection
end