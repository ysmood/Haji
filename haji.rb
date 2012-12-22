#!/usr/bin/env ruby

require_relative 'helpers/Haji_helper'

begin
  Ys::Haji_helper.new ARGV
rescue Exception => e
  puts "\n\nInterupted!"
end