# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','forge-cli','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'forge-cli'
  s.version = ForgeCli::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/forge
lib/forge-cli/version.rb
lib/forge-cli.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','forge-cli.rdoc']
  s.rdoc_options << '--title' << 'forge-cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'forge-cli'
  s.add_development_dependency('rake')
  s.add_development_dependency('rails', '3.2')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.5.6')
end
