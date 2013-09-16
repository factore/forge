resources :comments, :only => [:create, :destroy]

namespace :forge do
end

devise_for :users, :controllers => { :sessions => "sessions" }
devise_scope :user do
  get "/login" => "devise/sessions#new"
  get "/logout" => "sessions#destroy"
  get "/register" => "devise/registrations#new"
end

match "/sitemap", :controller => 'index', :action => 'sitemap', :via => :get
match '/pages/preview', :controller => 'pages', :action => 'preview', :via => :get
match '*slugs', :controller => 'pages', :action => 'show', :via => :get
root :to => "index#index"
