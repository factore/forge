require 'forge-cli/version.rb'
require 'forge-cli/application_creator.rb'
require 'forge-cli/module_installer.rb'
require 'forge-cli/ability_installer.rb'
require 'forge-cli/route_installer.rb'
require 'forge-cli/post_hooks.rb'
require 'yaml'
Dir[File.join(File.dirname(__FILE__), 'forge-cli', 'modules', '*', 'post_hooks.rb')].each do |hooks|
  require hooks
end

class ForgeCLI
  MODULES = Dir.entries(File.join(File.dirname(__FILE__), 'forge-cli', 'modules')).reject do |e|
    %w{. ..}.include?(e)
  end
end