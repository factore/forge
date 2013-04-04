require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true

    config.backtrace_clean_patterns = [
        /\/lib\d*\/ruby\//,
        /bin\//,
        #/gems/,
        /spec\/spec_helper\.rb/,
        /lib\/rspec\/(core|expectations|matchers|mocks)/
      ]
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

MySettings.site_url = "http://localhost:3000"
