require File.join(File.dirname(__FILE__), '..', 'scaffold', 'scaffold_generator.rb')
module Forge
  module Generators
    class ScaffoldSmallGenerator < Forge::Generators::ScaffoldGenerator
      source_root File.expand_path('../templates', __FILE__)
    end
  end
end