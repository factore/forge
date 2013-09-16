class ForgeCLI::ApplicationCreator
  def self.create!(app, modules = [])
    new(app, modules).create_application!
  end

  def initialize(app, modules = [])
    @app = app
    @modules = modules
  end

  def create_application!
    system("/usr/bin/env rails new #{@app} --skip-bundle")
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

    # create some new tokens
    generate_devise_tokens

    STDOUT.puts completed_message
  end

  def completed_message
    %{
#{"Your new Forge site is almost ready!  Next steps:".foreground(:cyan)}
  1.  Run 'bundle install'
  2.  Set up config/database.yml
  3.  Run 'rake db:create' unless your database already exists
  4.  Run 'rake db:migrate'
  5.  Run 'rake forge:create_admin'
  6.  Run 'rake forge:load_help'
  7.  Edit the contents of config/sitemap.yml, then run 'rake db:seed'
  8.  Review the settings in config/initializers/devise.rb and config/settings.yml
  9.  Run 'rails server' to spin up the application
  10. Access Forge by going to /forge in your browser (e.g. http://localhost:3000/forge)
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
        app_name = File.basename(@app).gsub(/\W+/, '_').camelize
        new_content = old_content.gsub('Forge3', app_name)
        File.open(File.join(@app, file), 'w') do |f|
          f.puts new_content
        end
      end
    end

    def generate_devise_tokens
      file = '/config/initializers/devise.rb'
      old_content = File.read(File.join(@app, file))
      new_content = old_content.gsub('DEVISE_SECRET_KEY', SecureRandom.hex(64)).gsub('DEVISE_PEPPER', SecureRandom.hex(64))
      File.open(File.join(@app, file), 'w') do |f|
        f.puts new_content
      end
    end
end
