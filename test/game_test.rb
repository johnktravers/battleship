require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require './lib/computer'
require './lib/player'

class GameTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)

    @computer_board = Board.new
    @player_board = Board.new
    @computer = Computer.new(@computer_board)
    @player = Player.new(@player_board)
    @game = Game.new(@computer_board, @player_board)
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_computer_and_player_boards
    assert_instance_of Board, @game.computer_board
    assert_instance_of Board, @game.player_board
  end

  def test_main_menu_display
    expected = "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
    assert_equal expected, @game.main_menu
  end

  def test_it_can_display_boards
    @computer.add_ship(@cruiser)
    @computer.add_ship(@submarine)
    @computer.place_ships

    @player_board.place(@cruiser, ["A1", "A2", "A3"])
    @player_board.place(@submarine, ["C3", "D3"])

    expected = "=============COMPUTER BOARD=============\n" +
               "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n" +
               "==============PLAYER BOARD==============\n" +
               "  1 2 3 4 \nA S S S . \nB . . . . \nC . . S . \nD . . S . \n"
    assert_equal expected, @game.display_boards
  end
end
