Forge3::Application.config.secret_token = begin
  Rails.root.join("config/secret_token.txt").read
rescue Errno::ENOENT
  $stderr.puts "Couldn't find a static secret token.  Generating a temporary one..."
  $stderr.puts "Next time, run: rake forge:secret"

  require 'digest/md5'

  Digest::MD5.hexdigest(`uname -a`)
end
