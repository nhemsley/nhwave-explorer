#!/usr/bin/env ruby
require 'pathname'
require 'pry'
require 'wavefront_obj'
require 'rmagick'

project_dir = Pathname.new(File.absolute_path(File.dirname(__FILE__)))

input_file = Pathname.new(Dir.pwd).join(ARGV[0])
height_per_percent = ARGV[1].to_f

input_rel = File.basename(input_file)

img = Magick::ImageList.new(input_file).first
# binding.pry
pixels = img.get_pixels(0,0,img.columns,img.rows)

heights = []
for i in (0..img.columns-1)
  rowstart = i*img.rows
  row = pixels[rowstart..rowstart+img.rows];
  row_mapped =  row.map(&:to_hsla).map{|p| (p[2] * height_per_percent).to_s.slice(0..5)}
  # max = Math.max(row.max_by{|p| p.to_hsla[2]})
  puts row_mapped.join('  ') << "\n"
end
