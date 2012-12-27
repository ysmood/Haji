# Define your new commands in here.
module Haji

  module Plugin
    
    # To add your own plugin, run 'haji p' in the shell.
    def p
      # This is an example of the plugin.
      # Edit the plugin file.
      exec("vim " + File.expand_path(__FILE__))
    end

  end

end