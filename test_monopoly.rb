#!/usr/bin/ruby -w

require 'test/unit'
require 'monopoly'

class TestMonopolyBoard < Test::Unit::TestCase
  def setup
    @board = Monopoly::Board.new
  end

  def test_square_count
    assert_equal 40, @board.squares.size
    assert_equal 4, @board.squares.select{|s| s[1] == :railroad}.size
    assert_equal 6, @board.squares.select{|s| s[1] == :draw}.size
    assert_equal 28, @board.squares.select{|s| s[1] == :property || s[1] == :railroad || s[1] == :util}.size
  end

  def test_dice_moves
    player_location = :go
    assert_equal :mediterranean_ave, @board.move(:go, 1)
    assert_equal :electric_co, @board.move(:go, 12)
    assert_equal :reading, @board.move(:vermont_ave, -3)
  end
end

class TestCards < Test::Unit::TestCase
  def test_card_count
    @chance = Monopoly::Cards::Chance.new
    @chest = Monopoly::Cards::CommunityChest.new

    assert_equal 16, @chance.card_names.size
    assert_equal 16, @chest.card_names.size

  end
end

