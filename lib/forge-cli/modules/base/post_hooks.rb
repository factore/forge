class ForgeCLI
  class BasePostHooks < ForgeCLI::PostHooks
    def run!
      STDOUT.puts "Installing Routes..."
      ri = ForgeCLI::RouteInstaller.new(@app, module_path)
      ri.install_routes
      ri.install_routes(:forge)

      fix_gemfile
    end

    def fix_gemfile
      if RUBY_VERSION.match(/^1\.9/)
        gemfile_content = File.read(File.join(@app, 'Gemfile'))
        new_content = gemfile_content.gsub("gem 'capybara', '~> 2.0.0'", "gem 'capybara'")
        new_content = gemfile_content.gsub("gem 'shoulda-matchers', '~> 2.0.0'", "gem 'shoulda-matchers'")
        new_content = new_content.gsub("gem 'forge-rad'", "gem 'forge-rad19'")

        File.open(File.join(@app, 'Gemfile'), 'w') do |f|
          f.puts new_content
        end
      end
    end

    private
      def module_path
        File.dirname(__FILE__)
      end
  end
end