# File: lib/forge/videos.rb
# Adds configuration options for videos
# eg.
#
# Forge.configure do |config|
#   config.videos.zencoder_api_key = '123xyz'
#   config.videos.zencoder_bucket = 'development'
# end

module Forge
  class Configuration
    def videos
      @videos ||= VideoConfiguration.new
    end

    class VideoConfiguration
      attr_accessor :zencoder_api_key, :zencoder_bucket
    end
  end
end