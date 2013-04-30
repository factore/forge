class ForgeCLI::CustomFileCopier
  attr_accessor :app
  def self.copy_files!(app)
    new(app).copy_files!
  end

  def initialize(app)
    @app = app
  end

  def copy_files!
    files.each do |file|
      rel_path = file.gsub(File.join(ENV["HOME"], '.forge') + "/", '')
      ForgeCLI::Output.write('create', rel_path)
      FileUtils.cp_r(file, @app)
    end
  end

  def files
    @files ||= Dir.glob(File.join(ENV["HOME"], '.forge', '{*,.*}')).
                   reject { |f| rejects.include?(File.basename(f)) }
  end

  def rejects
    %w{. .. .git}
  end
end