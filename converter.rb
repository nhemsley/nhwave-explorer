#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'
require 'mittsu'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

results_dir = project_dir.join('results')

input_file = Pathname.new(Dir.pwd).join(ARGV[0])

input_rel = File.basename(input_file)

binding.pry


module Mittsu
  class HeightMap
    def initialize(width, depth, heights)
      @width = width
      @depth = depth
      @heights = heights
    end

    def load(name='')
      init_load
      new_object(name)
      new_mesh
      for i in (1..width)
        for j in (1..depth)
          binding.pry
        end
      end
      end_mesh
      end_object
    end

    def init_load
      @face_offset = 0
      @group = Group.new
      @vertices = []
      @normals = []
      @uvs = []
    end

    def new_object(object_name = '')
      end_object
      @object = Object3D.new
      @object.name = object_name
    end

    def end_object
      return if @object.nil?
      end_mesh
      @group.add(@object)
      @object = nil
    end

    def new_mesh
      end_mesh
      new_object if @object.nil?
      @geometry = Geometry.new
      @mesh = Mesh.new(@geometry, @material || MeshLambertMaterial.new)
      @mesh.name = @object.name
      @mesh.name += " #{@material.name}" unless @material.nil?
    end

    def end_mesh
      return if @mesh.nil? || @vertices.empty?
      @geometry.vertices = @vertices

      @geometry.merge_vertices
      @geometry.compute_face_normals
      @geometry.compute_bounding_sphere

      @object.add(@mesh)
      @mesh = nil
    end

    def add_face(a, b, c, normal_inds = nil)
    if normal_inds.nil?
      @geometry.faces << face3(
        a.to_i - (@face_offset + 1),
        b.to_i - (@face_offset + 1),
        c.to_i - (@face_offset + 1)
      )
    else
      @geometry.faces << face3(
        a.to_i - (@face_offset + 1),
        b.to_i - (@face_offset + 1),
        c.to_i - (@face_offset + 1),
        normal_inds.take(3).map { |i| @normals[i.to_i - 1].clone }
      )
    end
  end


    def handle_triangle(faces, uvs, normal_inds)
      add_face(faces[0], faces[1], faces[2], normal_inds)

      if !uvs.nil? && !uvs.empty?
        add_uvs(uvs[0], uvs[1], uvs[2])
      end
    end

    def handle_face(faces, uvs = [], normal_inds = [])
      new_mesh if @mesh.nil?
      if faces[3].nil?
        handle_triangle(faces, uvs, normal_inds)
      else
        handle_quad(faces, uvs, normal_inds)
      end
    end

    def handle_quad(faces, uvs, normal_inds)
      handle_quad_triangle(faces, uvs, normal_inds, [0, 1, 3])
      handle_quad_triangle(faces, uvs, normal_inds, [1, 2, 3])
    end

    def handle_quad_triangle(faces, uvs, normal_inds, tri_inds)
      handle_triangle(
        faces.values_at(*tri_inds).compact,
        uvs.values_at(*tri_inds).compact,
        normal_inds.values_at(*tri_inds).compact
      )
    end
  end
end


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


heightmap = Mittsu::HeightMap.new(points.first.length, points.length, points)




exit

mesh.mesh_from_points(points)

output_file = results_dir.join(obj_file).to_s
mesh.save(output_file)

puts  output_file
