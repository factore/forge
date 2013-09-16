class ForgeCLI::PostPostHooks < ForgeCLI::PostHooks
  def run!
    add_routes
    add_controller_module
  end

  def add_routes
    STDOUT.puts "Adding Routes..."
    ri = ForgeCLI::RouteInstaller.new(@app, module_path)
    ri.install_routes
    ri.install_routes(:forge)
  end

  def add_controller_module
    STDOUT.puts "Adding Posts controller methods..."
    cmi = ForgeCLI::ControllerModuleIncluder.new(@app, 'posts')
    cmi.run!
  end

  def module_path
    File.dirname(__FILE__)
  end
end