namespace :deploy do
  desc "Deploy Forge"
  task :forge, :roles => :db do
    run "cd #{current_release}; bundle exec rake forge:deploy RAILS_ENV=production PASSWORD=#{ENV['PASSWORD']}"
  end
end