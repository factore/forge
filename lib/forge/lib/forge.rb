module Forge
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield config
  end

  class Configuration
    attr_accessor :mobile_layout, :support_instructions_in_layout,
                  :languages, :seo_callout, :support_instructions_in_help
  end
end