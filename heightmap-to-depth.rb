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
pixels = img.get_pixels(0,0,img.columns,img.rows)

heights = []
min = 0
max = 0
for i in (0..img.columns-1)
  rowstart = i*img.rows
  row = pixels[rowstart..rowstart+img.rows];
  row_mapped =  row.map(&:to_hsla).map{|p| (p[2] * height_per_percent)}
  heights << row_mapped

  #get the lowest and highest point on the whole depthmap
  min = [min, row_mapped.min].min
  max = [max, row_mapped.max].max
end

heights.pop

heights = heights.transpose

sea_level = max * 1.1
normalized = []
heights.each do |row|

  normalized_row = row.map {|height| sea_level - height}
  puts normalized_row.map{|c| c.to_s.slice(0..5)}.join('  ') << "\n"
end
