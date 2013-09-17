##############
### POSTS ####
##############
resources :posts, :only => [:index, :show] do
  collection do
    get   :feed
    patch :preview
    post  :preview
  end
  member do
    get :category
  end
end
match 'posts/:month/:year', :controller => 'posts', :action => 'index', :via => :get
##############
# END POSTS ##
##############
