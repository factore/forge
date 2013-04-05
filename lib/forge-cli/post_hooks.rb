class ForgeCLI
  class PostHooks
    class << self
      def run!(app)
        @app = app
      end

      def module_path
        raise NotImplementedError, "Set this to return File.dirname(__FILE__) in your subclass"
      end
    end
  end
end