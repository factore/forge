class ForgeCLI::GalleryPostHooks < ForgeCLI::PostHooks
  def run!
    STDOUT.puts "Adding routes..."
    ri = ForgeCLI::RouteInstaller.new(@app, module_path)
    ri.install_routes(:forge)
  end

  def module_path
    File.dirname(__FILE__)
  end
end