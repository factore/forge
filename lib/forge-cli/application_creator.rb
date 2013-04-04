class ForgeCLI
  class ApplicationCreator
    def self.create!(app)
      new(app).create_application!
    end

    def initialize(app)
      @app = app
    end

    def create_application!
      system("/usr/bin/env rails new #{@app}")
      ForgeCLI::ModuleInstaller.install_module!(:base, @app)
      puts "\nYour new Forge site is almost ready!  Next steps:"
      puts "  1. Run 'bundle install'"
      puts "  2. Run the migrations"
      puts "  3. Run rake forge:create_admin"
    end
  end
end