#!/usr/bin/env ruby

procs = `ps aux`
running = false
procs.each_line do |proc|
  running = true if proc.include?('httpd')
end
if running
  puts 'OK - httpd service is running'
  exit 0
else
  puts 'WARNING - httpd service is NOT running'
  exit 1
end

