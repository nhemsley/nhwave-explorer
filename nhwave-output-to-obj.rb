#!/usr/bin/env ruby
require 'pathname'
require 'wavefront_obj'

require_relative 'environment'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

input_file = ARGV[0]

input_rel = File.basename(input_file)

obj_file = input_rel << '.obj'

mesh = WavefrontObj.new
mesh.name = "Waves #{input_rel}"

depths = []
max_depth = min_depth = 0

File.foreach(input_file) do |line|
  row_arr = line.split(' ')

  row = row_arr.map { |depth| depth.to_f }

  depths << row

  min_depth = [min_depth, row.min].min
  max_depth = [max_depth, row.max].max

end

max_depth = max_depth * 500
#translate by max_depth to get heights
# translate = max_depth.to_i * 1.1
vertices = depths.map.with_index do |row, i|
  row.map.with_index {|v, j| [i.to_f, v*500, j.to_f]}
end

mesh.from_grid(vertices, 5)

puts mesh.get_raw_data
