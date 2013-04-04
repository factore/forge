require 'fileutils'
require 'active_support/core_ext/string'

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
      copy_files! if @mod["files"]
      create_migrations! if @mod["migrations"]
      post_hooks_class.run!(@app) if post_hooks_class
    end

    private
      def copy_files!
        @mod["files"].each do |file|
          source_file = File.join("#{base_path}", file)
          destination = File.join(app_path, file)
          destination_dir = File.dirname(destination)

          unless File.exist?(source_file)
            raise "FILE MISSING: #{source_file}"
          end

          unless Dir.exist?(destination_dir) && !File.directory?(source_file)
            STDOUT.puts "Create #{destination_dir}"
            FileUtils.mkdir_p(destination_dir)
          end

          if File.directory?(source_file)
            STDOUT.puts "Recursively create #{destination}"
            FileUtils.cp_r(source_file, destination)
          else
            STDOUT.puts "Create #{destination}"
            FileUtils.cp(source_file, destination)
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
        timestamp = Time.now.utc.to_s.gsub(/\D+/, '').to_i
        @mod["migrations"].each do |migration|
          # Get the old migration
          source_file = files.find {|f| f.match(%r{\d+_#{migration}.rb})}
          content = File.open(source_file, 'r').read

          # Write the new one
          new_file_path = File.join(destination_path, "#{timestamp}_#{migration}.rb")
          new_file = File.open(new_file_path, "w")
          new_file.puts content
          new_file.close
          STDOUT.puts "Wrote #{new_file_path}"

          # So that they have different timestamps in case order is important
          timestamp += 1
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