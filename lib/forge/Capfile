load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'bundler/capistrano'
load 'deploy/assets'
load 'lib/forge/recipes'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks