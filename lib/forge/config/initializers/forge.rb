require 'forge.rb'
require 'forge/can_be_foreign.rb'
require 'forge/can_have_comments.rb'
require 'forge/can_use_asset.rb'

# This configuration block is for config that should bes pecified
# by the site developer.  There is a Settings module built into Forge
# where you can expose other settings to your client.
Forge.configure do |config|
  # Enable a mobile layout for this website
  config.mobile_layout = false

  # Set up languages for front-end internationalization
  # Currently Forge is anglo-centric so you don't need to
  # specify English.
  #
  # config.languages = {
  #   "French" => :fr,
  #   "German" => :de
  #   # etc.
  # }

  # Print out support instructions for your client
  # in the bottom right-hand corner of Forge
  # config.support_instructions_in_layout = File.read("support.html")

  # Print out any additional SEO information you'd like
  # to display on the SEO tabs of supported modules
  # config.seo_callout = File.read("seo.html")

  # If you need to add further config options you can add them
  # in lib/forge.rb as attr_accessors to Forge::Configuration
end