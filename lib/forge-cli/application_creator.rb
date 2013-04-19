class ForgeCLI::ApplicationCreator < ForgeCLI::App
  def self.create!(app, modules = [])
    new(app, modules).create_application!
  end

  def initialize(app, modules = [])
    @app = app
    @modules = modules
  end

  no_commands do
    def create_application!
      system("/usr/bin/env rails new #{@app}")
      ForgeCLI::ModuleInstaller.install_module!(:base, @app)
      @modules.each do |mod|
        ForgeCLI::ModuleInstaller.install_module!(mod, @app)
      end

      # Remove some base Rails files that we don't want
      STDOUT.puts "Removing unneccessary base Rails files..."
      remove_file File.join(@app, 'app', 'views', 'layouts', 'application.html.erb')
      remove_file File.join(@app, 'app', 'assets', 'stylesheets', 'application.css')
      remove_file File.join(@app, 'public', 'index.html')
      remove_file File.join(@app, 'Gemfile.lock')


      STDOUT.puts completed_message
    end

    def completed_message
      %{
#{"Your new Forge site is almost ready!  Next steps:".foreground(:cyan)}
  1. Run 'bundle install'
  2. Set up config/database.yml
  3. Run 'rake db:migrate'
  4. Run 'rake forge:create_admin
      }
    end

    private
      def remove_file(file)
        if File.exist?(file)
          STDOUT.puts "      #{"remove".foreground(93, 255, 85)}  #{file.gsub(@app + '/', '')}"
          FileUtils.rm(file)
        end
      end

  end
end