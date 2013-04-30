class ForgeCLI::App < Thor
  include Thor::Actions

  desc 'new', 'Create a new Forge app'
  def new(app, modules = '')
    modules = modules.split(',')
    ForgeCLI::ApplicationCreator.create!(app, modules)
  end

  desc 'install', 'Install modules into the working Forge app'
  def install(modules)
    app = Dir.pwd
    modules = modules.split(',')
    modules.each do |mod|
      ForgeCLI::ModuleInstaller.install_module!(mod, app)
    end
  end

  desc 'list', 'List available Forge modules'
  def list
    puts "The following Forge modules are available: \n"
    ForgeCLI::MODULES.each do |mod|
      puts "  - #{mod}" unless mod == "base"
    end
  end
end