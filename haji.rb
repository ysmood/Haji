#!/usr/bin/env ruby
# The app entrance of Haji helper.
# Nov 2012 ys

require_relative 'lib/Helper'

module Haji
  
  begin
    Helper.new ARGV
  rescue Exception => e
    puts e
    puts "\nInterupted!"
  end

end