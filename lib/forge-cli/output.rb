class ForgeCLI::Output
  def self.write(action, message, output = STDOUT)
    msg = []
    (12 - action.length).times { msg << " " }
    msg << action.foreground(93, 255, 85)
    msg << "  "
    msg << message
    output.puts msg.join('')
  end
end
