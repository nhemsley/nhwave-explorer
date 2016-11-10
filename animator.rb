#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'
require 'wavefront'
require 'mittsu'


SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'Hello, World!'

scene = Mittsu::Scene.new

camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
camera.position.z = 5.0

box = Mittsu::Mesh.new(
  Mittsu::BoxGeometry.new(1.0, 1.0, 1.0),
  Mittsu::MeshBasicMaterial.new(color: 0x00ff00)
)

scene.add(box)

renderer.window.run do
  # box.rotation.x += 0.1
  # box.rotation.y += 0.1

  renderer.render(scene, camera)
end

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

obj_dir = project_dir.join('obj')


files = Dir["#{obj_dir.to_s}/*.obj"]

file = files.first.to_s

puts "Parsing #{file}"
binding.pry
w = Wavefront::File.new file

exit


input_file = ARGV[0]

input_abs = Dir[obj_dir.to_s + "/#{input_file}"].first

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

output_file = obj_dir.join(obj_file).to_s
mesh.save(output_file)

puts  output_file
