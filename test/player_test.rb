require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/game'

class PlayerTest < Minitest::Test

  def setup
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
    @player_cruiser = Ship.new("Cruiser", 3)
    @player_submarine = Ship.new("Submarine", 2)

    @computer_board = Board.new
    @player_board = Board.new
    @player = Player.new(@computer_board, @player_board)
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_computer_and_player_boards
    assert_equal @computer_board, @player.computer_board
    assert_equal @player_board, @player.player_board
  end

  def test_it_starts_with_no_ships_or_shot_coords
    assert_equal [], @player.player_ships
    assert_equal [], @player.computer_ships
    assert_equal [], @player.shot_coords
  end

  def test_player_ships_can_be_added
    @player.add_player_ship(@player_cruiser)
    @player.add_player_ship(@player_submarine)

    assert_equal [@player_cruiser, @player_submarine], @player.player_ships

    # @player.add_ship("Cruiser", 3)
    # @player.add_ship("Submarine", 2)
    #
    # assert_instance_of Ship, @player.player_ships[0]
    # assert_equal "Cruiser", @player.player_ships[0].name
    # assert_equal 3, @player.player_ships[0].length
    #
    # assert_instance_of Ship, @player.player_ships[1]
    # assert_equal "Submarine", @player.player_ships[1].name
    # assert_equal 2, @player.player_ships[1].length
  end

  def test_computer_ships_can_be_added
    @player.add_computer_ship(@computer_cruiser)
    @player.add_computer_ship(@computer_submarine)

    assert_equal [@computer_cruiser, @computer_submarine], @player.computer_ships
  end

end
