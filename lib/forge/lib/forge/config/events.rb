# File: lib/forge/videos.rb
# Adds configuration options for videos
# eg.
#
# Forge.configure do |config|
#   config.events.display = :calendar
# end

module Forge
  class Configuration
    attr_accessor :events

    def events
      @events ||= EventConfiguration.new
    end

    class EventConfiguration
      attr_accessor :display

      def initialize
        @display = :list
      end

      def display
        @display.to_sym
      end
    end
  end
end