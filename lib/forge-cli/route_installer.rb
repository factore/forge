class ForgeCLI::RouteInstaller < Thor
  def initialize(app, module_path)
    @app         = app
    @module_path = module_path
  end

  no_commands do
    def install_routes(type = :normal)
      file = File.join(@app, 'config', 'routes.rb')
      existing_routes = File.read(file)
      if type.to_sym == :normal
        routes_to_add = routes
        line = "Application.routes.draw do"
        indent = 2
      else
        routes_to_add = self.send("#{type}_routes")
        line = "namespace :#{type} do"
        indent = 4
      end
      routes = routes_to_add.split("\n").map {|r| " " * indent + r }.join("\n")
      updated_routes = existing_routes.gsub(line, "#{line}\n#{routes}")
      File.open(file, 'w') do |f|
        f.puts updated_routes
      end
    end

    def routes
      @routes ||= get_routes
    end

    def forge_routes
      @forge_routes ||= get_routes('forge_')
    end

    def get_routes(prefix = '')
      file = File.join(@module_path, "#{prefix}routes.rb")
      if File.exist?(file)
        File.open(file, "r").read
      end
    end
  end
end