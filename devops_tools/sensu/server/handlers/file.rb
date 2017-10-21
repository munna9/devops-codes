#!/usr/bin/env ruby

require 'rubygems'
require 'json'

# Read event data
event = JSON.parse(STDIN.read, :symbolize_names => true)
# Write the event data to a file
#file_name = "/tmp/sensu_#{event[:client][:name]}_#{event[:check][:name]}"
file_name = "/tmp/sensu_testserver2_cc_tomcat_check"
File.open(file_name, 'w') do |file|
  file.write(JSON.pretty_generate(event))
end

