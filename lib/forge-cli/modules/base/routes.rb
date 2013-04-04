devise_for :users, :controllers => { :sessions => "sessions" }
devise_scope :user do
  get "/login" => "devise/sessions#new"
  get "/logout" => "sessions#destroy"
  get "/register" => "devise/registrations#new"
end
resources :comments, :only => [:create, :destroy]

namespace :forge do
end

match "/sitemap", :controller => 'index', :action => 'sitemap'
root :to => "index#index"