module Forge
  # TODO: refactor this into a method
  Settings = YAML::load(File.open(Rails.root + 'config/settings.yml')).recursive_symbolize_keys!
end
