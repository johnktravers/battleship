require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/computer'
require './lib/game'

class ComputerTest < Minitest::Test

  def setup
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
    @player_cruiser = Ship.new("Cruiser", 3)
    @player_submarine = Ship.new("Submarine", 2)

    @computer_board = Board.new
    @player_board = Board.new
    @computer = Computer.new(@computer_board, @player_board)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_it_has_computer_and_player_boards
    assert_equal @computer_board, @computer.computer_board
    assert_equal @player_board, @computer.player_board
  end

  def test_it_starts_with_no_ships_or_shot_coords
    assert_equal [], @computer.computer_ships
    assert_equal [], @computer.player_ships
    assert_equal [], @computer.shot_coords
  end

  def test_computer_ships_can_be_added
    add_computer_cruiser_and_submarine

    assert_equal [@computer_cruiser, @computer_submarine], @computer.computer_ships
  end

  def test_it_can_select_a_random_coordinate
    actual = @player_board.cells.keys.include?(@computer.select_random_coord)
    assert_equal true, actual
  end

  def test_computer_picks_valid_random_coordinate_array
    cruiser_coords = @computer.create_random_coord_array(@computer_cruiser)

    actual = @computer.computer_board.valid_placement?(@computer_cruiser, cruiser_coords)
    assert_equal true, actual

    @computer.computer_board.place(@computer_cruiser, cruiser_coords)
    sub_coords = @computer.create_random_coord_array(@computer_submarine)

    actual = @computer.computer_board.valid_placement?(@computer_submarine, sub_coords)
    assert_equal true, actual
  end

  def test_ships_can_be_placed
    add_computer_cruiser_and_submarine
    @computer.place_ships

    assert_equal 5, @computer.computer_board.render(true).count("S")
  end

  def test_it_prompts_user_to_place_ships
    add_computer_cruiser_and_submarine
    add_player_cruiser_and_submarine

    expected = "I have laid out my ships on the grid.\n" +
               "You now need to lay out your two ships:\n" +
               "\n" +
               "  The Cruiser is three units long.\n" +
               "  The Submarine is two units long.\n"

    assert_equal expected, @computer.prompt_player
  end

  def test_shot_coords_array_updates_when_firing_upon_a_coord

  end

  def add_computer_cruiser_and_submarine
    @computer.add_computer_ship(@computer_cruiser)
    @computer.add_computer_ship(@computer_submarine)
  end

  def add_player_cruiser_and_submarine
    @computer.add_player_ship(@player_cruiser)
    @computer.add_player_ship(@player_submarine)
  end

end
