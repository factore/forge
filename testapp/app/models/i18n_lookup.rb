class I18nLookup
  def initialize(klass)
    @klass = klass
  end
  
  def fields
    self.class.fields[:tables][@klass.to_s.underscore.pluralize.to_sym]
  end
  
  def self.fields
    @@fields ||= YAML::load(File.open(Rails.root + 'config/i18n_fields.yml')).recursive_symbolize_keys!
  end
end