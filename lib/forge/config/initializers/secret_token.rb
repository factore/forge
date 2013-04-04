module Forge3::SecretToken
  LOCATION = if Rails.env.production?
    "/var/apps/#{File.basename(Dir.pwd)}/shared/secret_token.txt"
  else
    'config/secret_token.txt'
  end

  begin
    Forge3::Application.config.secret_token = File.read(LOCATION)
  rescue Errno::ENOENT
    $stderr.puts "WARNING: Couldn't find a secret token.  Generating one now..."

    Forge3::Application.config.secret_token = SecureRandom.hex(64)

    File.open(LOCATION, 'w') { |f| f.write(Forge3::Application.config.secret_token) }
  end
end
