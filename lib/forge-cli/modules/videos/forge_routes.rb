resources :videos, :except => [:show] do
  get 'play', 'encode', :on => :member
  post 'encode_notify', :on => :collection
end