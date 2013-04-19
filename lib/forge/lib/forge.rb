module Forge
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield config
  end

  class Configuration
    attr_accessor :mobile_layout
    attr_accessor :support_instructions_in_layout
  end
end