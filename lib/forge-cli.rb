require 'forge-cli/version.rb'
require 'forge-cli/application_creator.rb'
require 'forge-cli/module_installer.rb'
require 'forge-cli/post_hooks.rb'
Dir[File.join(File.dirname(__FILE__), 'forge-cli', 'modules', '*', 'post_hooks.rb')].each do |hooks|
  require hooks
end
require 'yaml'
# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file
class ForgeCLI
  MODULES = Dir.entries(File.join(File.dirname(__FILE__), 'forge-cli', 'modules')).reject do |e|
    %w{. ..}.include?(e)
  end
end