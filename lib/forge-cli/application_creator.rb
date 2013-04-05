class ForgeCLI
  class ApplicationCreator
    def self.create!(app, modules = [])
      new(app, modules).create_application!
    end

    def initialize(app, modules = [])
      @app = app
      @modules = modules
    end

    def create_application!
      system("/usr/bin/env rails new #{@app}")
      ForgeCLI::ModuleInstaller.install_module!(:base, @app)
      @modules.each do |mod|
        ForgeCLI::ModuleInstaller.install_module!(mod, @app)
      end

      # Remove some base Rails crap
      FileUtils.rm(File.join(@app, 'app', 'views', 'layouts', 'application.html.erb'))
      FileUtils.rm(File.join(@app, 'app', 'assets', 'stylesheets', 'application.css'))
      FileUtils.rm(File.join(@app, 'public', 'index.html'))

      STDOUT.puts completed_message
    end

    def completed_message
      %{
Your new Forge site is almost ready!  Next steps:
    1. Run 'bundle install'
    2. Set up config/database.yml
    3. Run 'rake db:migrate'
    4. Run 'rake forge:create_admin
      }
    end
  end
end