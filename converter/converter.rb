#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

results_dir = project_dir.join('results')

input_file = ARGV[0]

input_abs = Dir[results_dir.to_s + "/#{input_file}"].first

input_rel = File.basename(input_abs)

obj_file = input_rel << '.obj'

mesh = WavefrontObj.new
mesh.name = "Waves #{input_rel}"

points = []
y=0
File.foreach(input_abs) do |line|
  line_arr = line.split(' ')

  points << line_arr.map.with_index(0) do |p, x|
    [x.to_f, p.to_f * 100, y.to_f ]
  end

  # puts point_arr.inspect
  y = y + 1
end

mesh.mesh_from_points(points)

output_file = results_dir.join(obj_file).to_s
mesh.save(output_file)

puts  output_file
