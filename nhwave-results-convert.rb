#!/usr/bin/env ruby
require 'pathname'
require 'pry'

require_relative 'environment'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

results_dir = project_dir.join(ARGV[0])

out_dir = project_dir.join(ARGV[1])

files = Dir[results_dir.join('eta*').to_s].map{|f| File.basename(f)}
out_files = Dir[out_dir.join('eta*').to_s].map{|f| File.basename(f)}

out_files_orig = out_files.map{|f| c = f.split('.'); c.pop; c.join('.')}

need_to_convert = files - out_files

need_to_convert.each do |convert|
  input_file = results_dir.join(convert)
  output_file = out_dir.join("#{convert}.obj")
  puts "#{convert}"
  cmd_output = `bundle exec ./nhwave-output-to-obj.rb #{input_file}`
  File.open(output_file, 'w') { |file| file.write(cmd_output) }
end
