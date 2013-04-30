resources :posts
resources :post_categories, :except => [:show, :new]
resources :comments, :only => [:index, :destroy] do
 put     'approve', :on => :member
 put     'unapprove', :on => :member
end