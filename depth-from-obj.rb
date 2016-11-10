#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'
require 'mittsu'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

results_dir = project_dir.join('results')

input_file = Pathname.new(Dir.pwd).join(ARGV[0])

input_rel = File.basename(input_file)

if (false)

  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  ASPECT = SCREEN_WIDTH.to_f / SCREEN_HEIGHT.to_f

  renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: 'Hello, World!'

  scene = Mittsu::Scene.new

  camera = Mittsu::PerspectiveCamera.new(75.0, ASPECT, 0.1, 1000.0)
  camera.position.z = 5.0

end

loader = Mittsu::OBJLoader.new
model = loader.load(input_file)

mesh = model.children.first.children.first

vertices =  mesh.geometry.vertices

stride = Math.sqrt(vertices.length).to_i

idx = 4
#group by our x coord, to get each 'row'.
grouped = vertices.group_by do |v|
  ret =
  if v.x < 0
    ret = v.x.to_s[0..idx+1]
  else
    ret =  v.x.to_s[0..idx]
  end
  ret
end

#sort via keys
sorted_rows = grouped.keys.sort.map {|k| grouped[k]}

output = []

sorted_rows.each do |row|
  #sort by z, as this is the column order
  col = row.sort_by{|v| v.z}
  #map to depths
  depths = col.map {|v| v.y}
  output << depths
end

stride = output.max_by(&:length).length

ok = output.reject{|a| a.length != stride}

min = ok.flatten.min

if min < 0
  min = -min
else
  min=0
end

ok.each do |row|
  output = row.map{|a| (a+min).to_s[0..5]}.join('    ')
  puts "#{output}\n"
end


binding.pry
puts 'here'
exit

scene.add(model)


renderer.window.run do
  # box.rotation.x += 0.1
  # box.rotation.y += 0.1

  renderer.render(scene, camera)
end
