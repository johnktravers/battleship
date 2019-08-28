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
    # @computer_cruiser = Ship.new("Cruiser", 3)
    # @computer_submarine = Ship.new("Submarine", 2)
    # @player_cruiser = Ship.new("Cruiser", 3)
    # @player_submarine = Ship.new("Submarine", 2)

    # @computer_board = Board.new
    # @player_board = Board.new
    # @computer = Computer.new(@computer_board, @player_board)
    # @player = Player.new(@computer_board, @player_board)

    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_starts_without_computer_and_player_boards
    assert_nil @game.computer_board
    assert_nil @game.player_board
  end

  def test_it_starts_without_any_ships_or_shot_coords
    assert_equal [], @game.total_ships
    assert_equal [], @game.computer_shot_coords
    assert_equal [], @game.player_shot_coords
  end

  def test_no_cells_are_occupied_by_ships_to_start
    assert_equal 0, @game.squares_occupied
  end

  def test_it_starts_with_cruiser_and_submarine_attributes
    assert_equal [["Cruiser", 3], ["Submarine", 2]], @game.ship_attrs
  end

  def test_it_can_create_ships
    assert_equal 2, @game.create_ships.length

    assert_instance_of Ship, @game.create_ships[0]
    assert_equal "Cruiser", @game.create_ships[0].name
    assert_equal 3, @game.create_ships[0].length

    assert_instance_of Ship, @game.create_ships[1]
    assert_equal "Submarine", @game.create_ships[1].name
    assert_equal 2, @game.create_ships[1].length
  end

  # def test_main_menu_display
  #   expected = "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
  #   assert_equal expected, @game.main_menu
  # end

  # def test_it_can_display_boards
  #   @computer.add_computer_ship(@computer_cruiser)
  #   @computer.add_computer_ship(@computer_submarine)
  #   @computer.place_ships
  #
  #   @computer.add_player_ship(@player_cruiser)
  #   @computer.add_player_ship(@player_submarine)
  #
  #   @player.add_computer_ship(@computer_cruiser)
  #   @player.add_computer_ship(@computer_submarine)
  #
  #   @player_board.place(@player_cruiser, ["A1", "A2", "A3"])
  #   @player_board.place(@player_submarine, ["C3", "D3"])
  #
  #   expected = "=============COMPUTER BOARD=============\n" +
  #              "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n" +
  #              "\n" +
  #              "==============PLAYER BOARD==============\n" +
  #              "  1 2 3 4 \nA S S S . \nB . . . . \nC . . S . \nD . . S . \n" +
  #              "\n"
  #   assert_equal expected, @game.display_boards
  # end

end
