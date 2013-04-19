resources :assets do
  get 'drawer', :on => :collection
  get 'place', 'prepare', :on => :member
  post 'encode_notify', :on => :collection
end

resources :comments, :only => [:index, :destroy] do
 put     'approve', :on => :member
 put     'unapprove', :on => :member
end

resources :pages do
  post    'reorder', :on => :collection
end

resources :users, :except => [:show] do
  get 'approve', :on => :member
end

resource :settings, :only => [:show, :update]

resources :help_topics, :only => [:index, :show]

match "help", :controller => :help_topics, :action => :index
match "help/search", :controller => :help_topics, :action => :search
match "help/:slug", :controller => :help_topics, :action => :show

root :to => "index#index"