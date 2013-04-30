class ForgeCLI::EventPostHooks < ForgeCLI::PostHooks
  def run!
    STDOUT.puts "Adding routes..."
    ri = ForgeCLI::RouteInstaller.new(@app, module_path)
    ri.install_routes
    ri.install_routes(:forge)

    STDOUT.puts "Adding config requires..."
    require_addon(:events)
  end


  def module_path
    File.dirname(__FILE__)
  end
end