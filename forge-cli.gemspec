# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','forge-cli','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'forge-cli'
  s.version = ForgeCLI::VERSION
  s.author = 'factor[e] design initiative'
  s.email = 'sean@factore.ca'
  s.homepage = 'http://factore.ca/forge-cms'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Forge: A CMS for Rapid Application Development'
  # Add your other files here if you make them
  s.files = Dir.glob("{bin,lib}/**/*")

  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'forge-cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'forge'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_dependency('rails', '3.2.13')
  s.add_dependency('rainbow')

  s.add_dependency('thor')
end
