module Forge
  module CanBeForeign
    def self.included(mod)
      mod.extend(ClassMethods)
    end
    
    module ClassMethods
      def foreign_fields
        Forge::I18nFields[self.to_s.downcase.to_sym]
      end
    end
  end
end

ActiveRecord::Base.send(:include, Forge::CanBeForeign)