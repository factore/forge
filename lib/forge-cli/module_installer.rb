class ForgeCLI
  class ModuleInstaller
    def self.install_module!(module_name, app)
      mi = new(module_name, app)
      mi.run!
    end

    def initialize(module_name, app)
      @module_name  = module_name.to_s
      @mod          = module_manifest
      @app          = app
    end

    def run!
      unless @module_name == "base"
        STDOUT.puts "\nInstalling #{@module_name.titleize}..."
      end
      install_dependencies! if @mod["dependencies"]
      copy_files!           if @mod["files"]
      delete_files!         if @mod["delete"]
      create_migrations!    if @mod["migrations"]

      post_hooks_class.run!(@app) if post_hooks_class
      unless @module_name == "base"
        STDOUT.puts "Done!"
      end
    end

    private
      def install_dependencies!
        @mod["dependencies"].each do |dependency|
          ForgeCLI::ModuleInstaller.install_module!(dependency, @app)
        end
      end

      def copy_files!
        @mod["files"].each do |file|
          source_file = File.join(base_path, file)
          destination = File.join(app_path, file)
          destination_dir = File.dirname(destination)

          unless File.exist?(source_file)
            raise "FILE MISSING: #{source_file}"
          end

          unless File.exist?(destination_dir) && !File.directory?(source_file)
            STDOUT.puts "      #{"create".foreground(93, 255, 85)}  #{file}"
            FileUtils.mkdir_p(destination_dir)
          end

          if File.directory?(source_file)
            Dir[File.join(source_file, '**', '*')].each do |s|
              source_file = s
              destination = File.join(app_path, s.gsub(base_path, ''))
              destination_dir = File.dirname(destination)
              FileUtils.mkdir_p(destination_dir)
              unless File.directory?(source_file)
                FileUtils.cp(source_file, destination)
              end
            end
          else
            FileUtils.cp(source_file, destination)
          end
        end
      end

      def delete_files!
        @mod["delete"].each do |file|
          raise "You can't delete non-app files" if file.match(/^\//)
          destination = File.join(app_path, file)
          if File.exist?(destination)
            STDOUT.puts "      #{"remove".foreground(93, 255, 85)}  #{file}"
            FileUtils.rm(destination)
          end
        end
      end

      def create_migrations!
        source_path = File.join(base_path, 'db', 'migrate')
        destination_path = File.join(app_path, 'db', 'migrate')
        unless File.exist?(destination_path)
          FileUtils.mkdir_p(destination_path)
        end
        files = Dir[File.join(source_path, '*.rb')]
        @mod["migrations"].each do |migration|
          # Get the old migration
          source_file = files.find {|f| f.match(%r{\d+_#{migration}.rb})}
          content = File.open(source_file, 'r').read

          # Write the new one
          timestamp = Time.now.strftime('%Y%m%d%H%M%S')
          new_file_path = File.join(destination_path, "#{timestamp}_#{migration}.rb")
          new_file = File.open(new_file_path, "w")
          new_file.puts content
          new_file.close
          STDOUT.puts "   migration  ".foreground(93, 255, 85) + new_file_path.gsub("#{destination_path}/", '')

          # So that they have different timestamps
          sleep 1
        end
      end

      def base_path
        @base_path ||= File.join(File.dirname(__FILE__), "..", "forge")
      end

      def app_path
        @app_path ||= File.join(Dir.pwd, @app)
      end

      def module_manifest
        @module_manifest = YAML.load_file(File.join(File.dirname(__FILE__), 'modules', @module_name, 'manifest.yml'))
      end

      def post_hooks_class
        begin
          "ForgeCLI::#{@module_name.classify}PostHooks".constantize
        rescue NameError
          nil
        end
      end
  end
end