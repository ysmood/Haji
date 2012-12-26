# The main data class of the helper.
# Dec 2012 ys

module Haji
  class Data

    def initialize
      @version = 0.8
    end

    attr_reader :version

    attr_accessor \
      :name,
      :email
    
  end
end