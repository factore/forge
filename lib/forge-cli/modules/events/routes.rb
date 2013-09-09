resources :events
if Forge.config.events.try(:display) == :calendar
  match 'events/:year/:month' => 'events#index', :via => :get
end
