#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'

require_relative 'environment'

#Converts a nhwave depth.txt file into a wavefront.obj file


project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

input_file = ARGV[0]

input_rel = File.basename(input_file)

obj_file = input_rel << '.obj'

mesh = WavefrontObj.new
mesh.name = "Waves #{input_rel}"

points = []
y=0
File.foreach(input_file) do |line|
  line_arr = line.split(' ')

  points << line_arr.map.with_index(0) do |depth, x|
    [x.to_f, depth.to_f, y.to_f ]
  end

  min = [min, row_mapped.min_by{|d| d.depth}].min
  max = [max, row_mapped.max_by{|d| d.depth}].max

  # puts point_arr.inspect
  y = y + 1
end

mesh.from_grid(points, 5)

puts mesh.get_raw_data
