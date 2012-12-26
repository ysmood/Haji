#!/usr/bin/env ruby

require_relative 'lib/Helper'

begin
  Haji::Helper.new ARGV
rescue Exception => e
  puts "\n\nInterupted!"
end