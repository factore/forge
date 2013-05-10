class ForgeCLI::EcommercePostHooks < ForgeCLI::PostHooks
  def run!
    STDOUT.puts "Adding Routes..."
    ri = ForgeCLI::RouteInstaller.new(@app, module_path)
    ri.install_routes
    ri.install_routes(:forge)

    STDOUT.puts "Adding eCommerce controller methods..."
    content = app_controller_content.gsub(
        'class ApplicationController < ActionController::Base',
        "class ApplicationController < ActionController::Base\n  include Forge::Controllers::ECommerce\n"
    )
    content = "require 'forge/shared_controller_methods/ecommerce.rb'\n" + content
    File.open(app_controller_path, 'w') do |f|
      f.puts content
    end

    STDOUT.puts "Adding config requires..."
    require_addon(:ecommerce)
  end


  def module_path
    File.dirname(__FILE__)
  end

  def app_controller_path
    File.join(@app, 'app', 'controllers', 'application_controller.rb')
  end

  def app_controller_content
    @app_controller_content ||= File.read(app_controller_path)
  end
end