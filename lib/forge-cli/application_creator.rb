class ForgeCLI::ApplicationCreator
  def self.create!(app, modules = [])
    new(app, modules).create_application!
  end

  def initialize(app, modules = [])
    @app = app
    @modules = modules
  end

  def create_application!
    system("/usr/bin/env rails new #{@app}")
    app_path = File.join(Dir.pwd, @app)
    ForgeCLI::ModuleInstaller.install_module!(:base, @app, app_path)
    @modules.each do |mod|
      ForgeCLI::ModuleInstaller.install_module!(mod, @app, app_path)
    end

    # Remove some base Rails files that we don't want
    STDOUT.puts "\nRemoving unneccessary base Rails files..."
    remove_file File.join(@app, 'app', 'views', 'layouts', 'application.html.erb')
    remove_file File.join(@app, 'app', 'assets', 'stylesheets', 'application.css')
    remove_file File.join(@app, 'public', 'index.html')
    remove_file File.join(@app, 'Gemfile.lock')

    # Copy custom files from ~/.forge
    if File.exist?(File.join(ENV["HOME"], '.forge'))
      STDOUT.puts "\nCopying your custom files from ~/.forge"
      ForgeCLI::CustomFileCopier.copy_files!(@app)
    end

    # Rewrite Forge3::Application
    rewrite_app_name

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

    def rewrite_app_name
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
end