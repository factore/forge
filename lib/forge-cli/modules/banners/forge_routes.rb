resources :banners, :except => [:show] do
  post    'reorder', :on => :collection
end