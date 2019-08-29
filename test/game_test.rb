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

  def test_board_height_and_width_are_0_to_start
    assert_equal 0, @game.height
    assert_equal 0, @game.width
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

end
