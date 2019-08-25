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
    @board = Board.new
    @player = Player.new(@board)
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_a_board
    assert_equal @board, @player.board
  end

  def test_it_starts_with_no_ships
    assert_equal [], @player.ships
  end

  def test_ships_can_be_added
    @player.add_ship(@cruiser)
    @player.add_ship(@submarine)

    assert_equal [@cruiser, @submarine], @player.ships
  end

  def test_player_is_presented_rendered_board
    @player.add_ship(@cruiser)
    expected = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n" +
               "Enter the squares for the Cruiser (3 spaces):\n> "
    assert_equal expected, @player.present_board
  end

end
