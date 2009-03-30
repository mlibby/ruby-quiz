#!/usr/bin/ruby -w

def find_squares(surface)
  #assumed: surface is square, at least 3x3
  width = height = surface.count
  squares = []

  0.upto(height - 2) do |y|
    row = []

    0.upto(width - 2) do |x|
      upper_left = surface[y][x]
      upper_right = surface[y][x+1]
      lower_left = surface[y+1][x]
      lower_right = surface[y+1][x+1]
      row << [ upper_left, upper_right, lower_left, lower_right ]
    end

    squares << row
  end

  squares
end
