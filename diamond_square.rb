#!/usr/bin/ruby -w

require 'rubygems'
require 'RMagick'

max_rgb = Magick::QuantumRange

img = Magick::Image.new(257,257)

0.upto(256) do |x|
  0.upto(256) do |y|
    img.pixel_color(x, y, Magick::Pixel.new(x**2, (x-y)**2, y**2, 30000))
  end
end

img.write("surface.gif")
