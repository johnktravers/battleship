require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/game'

class PlayerTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @player_ships = [@cruiser, @submarine]

    @player_board = Board.new(4, 4)
    @player = Player.new(@player_board, @player_ships)
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_a_board_and_ships
    assert_equal @player_board, @player.player_board
    assert_equal @player_ships, @player.player_ships
  end

end
