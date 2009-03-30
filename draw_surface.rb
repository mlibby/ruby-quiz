#!/usr/bin/ruby -w

require 'rubygems'
require 'RMagick'

max_rgb = Magick::QuantumRange

def draw_surface(surface, width , height)
  img = Magick::Image.new(width+1,height+1)
  light_factor = 100.0 / width
  0.upto(height) do |y|
    x_pixels = (width - 1) / (surface.count - 1)
    0.upto(surface.count - 2) do |xx|
      puts "looping x part #{xx * x_pixels} - #{(xx + 1) * x_pixels}"
      (xx * x_pixels).upto((xx + 1) * x_pixels) do |x|
        saturation = lightness = x * light_factor
        img.pixel_color(x, y, Magick::Pixel.from_hsla(128, saturation, lightness, 1.0))
      end
    end
  end
  img.write("surface.gif")
end

surface = [0.0, 1.0, 0.0]
draw_surface(surface, 512, 512)
