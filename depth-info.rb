#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'

require_relative 'environment'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

input_file = ARGV[0]

input_rel = File.basename(input_file)

obj_file = input_rel << '.obj'

depths = []
max_depth = 0
min_depth = 10

File.foreach(input_file) do |line|
  row_arr = line.split(' ')

  row = row_arr.map { |depth| depth.to_f }

  depths << row


  min_depth = [min_depth, row.min].min
  max_depth = [max_depth, row.max].max

end

  puts "Min Depth: #{min_depth}"
  puts "Max Depth: #{max_depth}"
  puts "Rows: #{depths.length}"
  puts "Columns: #{depths.first.length}"
