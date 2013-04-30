resources :galleries, :except => [:show] do
  post    'reorder', :on => :collection
end