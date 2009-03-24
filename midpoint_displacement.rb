#!/usr/bin/ruby -w

require 'RMagick'

def get_displaced_midpoint(left, right, range)
  mid = (left + right) / 2.0
  adj = (rand * range) * (0 == rand(2) ? -1 : 1)
  return mid + adj
end

def displace_line(line, range)
  offset = 1
  0.upto(line.length - 2) do |x|
    line.insert(x + offset, get_displaced_midpoint(line[x + offset - 1], line[x + offset], range))
    offset += 1
  end
  return line
end

def draw_line(iter, line, range, width, height, anim_list)
  drawing = Magick::Draw.new
  x_factor = width / (line.count - 1)
  0.upto(line.count - 2) do |x|
    drawing.line x_factor * x, (height/2) - (height * line[x] / 2), x_factor * (x + 1), (height / 2) - (height * line[x + 1] / 2)
  end
  drawing.stroke("transparent")
  drawing.fill("black")
  drawing.text(4, 16, "Iteration #{iter}, Range +/- #{range}")

  #draw frame
  img = Magick::Image.new(width, height, Magick::HatchFill.new('white', 'lightcyan2'))
  drawing.draw(img)
  img.write("line_img_#{'%03d' % iter}.gif")

  anim_list << img.copy
end

def print_line(iter, line, range)
  puts "iteration #{iter} (range=#{range}): #{line.inspect}"
end

def perform_iterations(line, iterations, range, roughness)
  1.upto(iterations) do |i|
    line = displace_line(line, range)
    yield(i, line, range)
    range *= 2 ** (0 - roughness)
  end
end

anim = Magick::ImageList.new
width = 512
height = 512
iterations = (Math.log(width) / Math.log(2)).to_i
roughness = 1.0

perform_iterations([0.0, 0.0], iterations, 0.5, roughness){|iter, line, range|
  draw_line(iter, line, range, width, height, anim)
  print_line(iter, line, range)
}

anim.delay = 100
anim.cur_image.delay = 300
anim.iterations = 0
anim.write("line_anim.gif")

