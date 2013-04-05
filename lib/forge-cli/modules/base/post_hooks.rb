require 'active_support/core_ext/string'

class ForgeCLI
  class BasePostHooks < ForgeCLI::PostHooks
    def self.run!(app)
      @app = app

      STDOUT.puts "Installing Routes..."
      ri = ForgeCLI::RouteInstaller.new(@app, module_path)
      ri.install_routes
      ri.install_routes(:forge)

      STDOUT.puts "Fixing Application Constant..."
      rewrite_app_name

      fix_gemfile
    end

    def self.rewrite_app_name
      files = [
        '/config/environments/production.rb',
        '/config/application.rb'
      ]
      files.each do |file|
        old_content = File.read(File.join(@app, file))
        app_name = File.basename(@app).classify
        new_content = old_content.gsub('Forge3', app_name)
        File.open(File.join(@app, file), 'w') do |f|
          f.puts new_content
        end
      end
    end

    def self.fix_gemfile
      unless RUBY_VERSION.match(/^1\.8/)
        gemfile_content = File.read(File.join(@app, 'Gemfile'))
        new_content = gemfile_content.gsub("gem 'forge-rad'", "gem 'forge-rad19'")
        File.open(File.join(@app, 'Gemfile'), 'w') do |f|
          f.puts new_content
        end
      end
    end

    def self.module_path
      File.dirname(__FILE__)
    end
  end
end