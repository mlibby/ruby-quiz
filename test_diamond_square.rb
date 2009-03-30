#!/usr/bin/ruby -w

require 'test/unit'
require 'diamond_square'

class TestDiamondSquare < Test::Unit::TestCase

  def test_should_find_subsquares
    surface =
      [
       [0.0, 0.0, 0.0],
       [0.0, 1.0, 0.0],
       [0.0, 0.0, 0.0]
      ]

    squares =
      [
       [[0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 1.0, 0.0]],
       [[0.0, 1.0, 0.0, 0.0], [1.0, 0.0, 0.0, 0.0]],
      ]

    # Squares are defined as an array of four floats containing
    # the vertices: upper-left, upper-right, lower-left, lower-right
    assert_equal(squares,
                 find_squares(surface),
                 "Should find 'sub' squares within larger 2d array")
  end

end
