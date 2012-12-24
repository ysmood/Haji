module Haji
  class Data

    def initialize
      if not @ver
        s = File.read(File.dirname(__FILE__) + '/init_welcome_msg.sh')
        @ver = s.match(/ver=(?<v>.+)\s/)[:v]
      end
    end
    
    attr_accessor :ver
    
  end
end