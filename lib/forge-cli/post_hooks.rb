class ForgeCLI::PostHooks
  def self.run!(app)
    new(app).run!
  end

  def initialize(app)
    @app = app
  end

  def run!
    raise NotImplementedError
  end

  private
    def module_path
      raise NotImplementedError, "Set this to return File.dirname(__FILE__) in your subclass"
    end

    def require_addon(addon)
      addon_requirer.require_addon(addon)
    end

    def addon_requirer
      @addon_requirer ||= ForgeCLI::ForgeAddonRequirer.new(@app)
    end
end