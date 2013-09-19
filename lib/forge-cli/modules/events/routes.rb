resources :events, :only => [:index, :show] do
  collection do
    patch :preview
    post  :preview
  end
end
if Forge.config.events.try(:display) == :calendar
  match 'events/:year/:month' => 'events#index', :via => :get
end
