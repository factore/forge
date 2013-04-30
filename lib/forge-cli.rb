class ForgeCLI
  MODULES = Dir.entries(File.join(File.dirname(__FILE__), 'forge-cli', 'modules')).reject do |e|
    %w{. ..}.include?(e)
  end
end

# This order is required
require 'active_support/core_ext/string'
require 'fileutils'
require 'rainbow'
require 'thor'
require 'yaml'
require 'forge-cli/version.rb'
require 'forge-cli/app.rb'

# This is alphabetical
require 'forge-cli/ability_installer.rb'
require 'forge-cli/application_creator.rb'
require 'forge-cli/custom_file_copier.rb'
require 'forge-cli/forge_addon_requirer.rb'
require 'forge-cli/module_installer.rb'
require 'forge-cli/output.rb'
require 'forge-cli/post_hooks.rb'
require 'forge-cli/route_installer.rb'

# Require the post hooks from all the modules
Dir[File.join(File.dirname(__FILE__), 'forge-cli', 'modules', '*', 'post_hooks.rb')].each do |hooks|
  require hooks
end