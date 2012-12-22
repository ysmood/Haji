#!/usr/bin/env ruby

require_relative 'helpers/Helper'

begin
  Haji::Helper.new ARGV
rescue Exception => e
  puts "\n\nInterupted!"
end