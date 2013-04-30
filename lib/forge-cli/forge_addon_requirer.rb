class ForgeCLI::ForgeAddonRequirer
  def initialize(app)
    @app = app
  end

  def require_addon(addon)
    file = File.join(@app, 'config', 'initializers', 'forge.rb')
    content = File.read(file)
    new_content = content.gsub("require 'forge.rb'", "require 'forge.rb'\nrequire 'forge/config/#{addon}.rb'")
    File.open(file, 'w') do |f|
      f.puts new_content
    end
  end
end