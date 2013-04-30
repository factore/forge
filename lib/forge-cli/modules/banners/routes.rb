##############
### POSTS ####
##############
resources :posts, :only => [:index, :show] do
  collection do
    get :preview, :feed
  end
  member do
    get :category
  end
end
match 'posts/:month/:year', :controller => 'posts', :action => 'index'
##############
# END POSTS ##
##############
