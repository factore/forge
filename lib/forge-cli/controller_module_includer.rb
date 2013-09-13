class ForgeCLI::ControllerModuleIncluder
  attr_reader :module_name

  def initialize(app, module_name)
    @app = app
    @module_name = module_name
  end

  def run!
    add_initializer_content
    add_controller_content
  end

  private
    def add_controller_content
      content = app_controller_content.gsub(
          'class ApplicationController < ActionController::Base',
          "class ApplicationController < ActionController::Base\n  include Forge::Controllers::#{module_name.camelize}\n"
      )
      File.open(app_controller_path, 'w') { |f| f.puts content }
    end

    def add_initializer_content
      content = "require 'forge/shared_controller_methods/#{module_name.downcase.underscore.gsub(/\s/, '_')}.rb'\n" + forge_initializer_content
      File.open(forge_initializer_path, 'w') { |f| f.puts content }
    end

    def app_controller_path
      File.join(@app, 'app', 'controllers', 'application_controller.rb')
    end

    def app_controller_content
      @app_controller_content ||= File.read(app_controller_path)
    end

    def forge_initializer_path
      File.join(@app, 'config', 'initializers', 'forge.rb')
    end

    def forge_initializer_content
      @forge_initializer_content ||= File.read(forge_initializer_path)
    end
end
