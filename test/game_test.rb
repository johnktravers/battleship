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
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
    @player_cruiser = Ship.new("Cruiser", 3)
    @player_submarine = Ship.new("Submarine", 2)

    @computer_board = Board.new
    @player_board = Board.new
    @computer = Computer.new(@computer_board, @player_board)
    @player = Player.new(@computer_board, @player_board)
    @game = Game.new(@computer_board, @player_board)
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_computer_and_player_boards
    assert_instance_of Board, @game.computer_board
    assert_instance_of Board, @game.player_board
  end

  # def test_main_menu_display
  #   expected = "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
  #   assert_equal expected, @game.main_menu
  # end

  def test_it_can_display_boards
    @computer.add_computer_ship(@computer_cruiser)
    @computer.add_computer_ship(@computer_submarine)
    @computer.place_ships

    @computer.add_player_ship(@player_cruiser)
    @computer.add_player_ship(@player_submarine)

    @player.add_computer_ship(@computer_cruiser)
    @player.add_computer_ship(@computer_submarine)

    @player_board.place(@player_cruiser, ["A1", "A2", "A3"])
    @player_board.place(@player_submarine, ["C3", "D3"])

    expected = "=============COMPUTER BOARD=============\n" +
               "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n" +
               "==============PLAYER BOARD==============\n" +
               "  1 2 3 4 \nA S S S . \nB . . . . \nC . . S . \nD . . S . \n"
    assert_equal expected, @game.display_boards
  end

  def test_it_displays_game_results

  end
end
