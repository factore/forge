class ForgeCLI::AbilityInstaller
  class << self
    def install_abilities!(app, ability_class)
      @app = app
      @ability_class = ability_class
      new_content = File.read(ability_file).gsub(
        /  end\nend\z/,
        "    #{ability_invocation}\n  end\nend"
      )
      File.open(ability_file, "w") do |f|
        f.puts new_content
      end
    end

    def ability_file
      File.join(@app, 'app', 'models', 'ability.rb')
    end

    def ability_invocation
      "#{@ability_class}.new(u)"
    end
  end
end