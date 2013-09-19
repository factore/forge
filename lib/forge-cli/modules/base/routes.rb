resources :comments, :only => [:create, :destroy]

namespace :forge do
end

devise_for :users, :skip => [:registrations], :controllers => { :sessions => "sessions" }
devise_scope :user do
  get "/login" => "devise/sessions#new"
  get "/logout" => "sessions#destroy"
end

match "/sitemap", :controller => 'index', :action => 'sitemap', :via => :get
match '/pages/preview', :controller => 'pages', :action => 'preview', :via => [:post, :patch]
match '*slugs', :controller => 'pages', :action => 'show', :via => :get
root :to => "index#index"
