require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/computer'
require './lib/game'

class ComputerTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @board = Board.new
    @computer = Computer.new(@board)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_it_has_a_board
    assert_equal @board, @computer.board
  end

  def test_it_starts_with_no_ships
    assert_equal [], @computer.ships
  end

  def test_ships_can_be_added
    add_cruiser_and_submarine

    assert_equal [@cruiser, @submarine], @computer.ships
  end

  def test_it_can_select_a_random_coordinate
    actual = @board.cells.keys.include?(@computer.select_random_coord)
    assert_equal true, actual
  end

  def test_computer_picks_valid_random_coordinate_array
    cruiser_coords = @computer.create_random_coord_array(@cruiser)

    actual = @computer.board.valid_placement?(@cruiser, cruiser_coords)
    assert_equal true, actual

    @computer.board.place(@cruiser, cruiser_coords)
    sub_coords = @computer.create_random_coord_array(@submarine)

    actual = @computer.board.valid_placement?(@submarine, sub_coords)
    assert_equal true, actual
  end

  def test_ships_can_be_placed
    add_cruiser_and_submarine
    @computer.place_ships

    assert_equal 5, @computer.board.render(true).count("S")
  end

  def test_it_prompts_user_to_place_ships
    add_cruiser_and_submarine

    expected = "I have laid out my ships on the grid.\n" +
               "You now need to lay out your two ships:\n" +
               "  The Cruiser is three units long.\n" +
               "  The Submarine is two units long.\n"

    assert_equal expected, @computer.prompt_player
  end

  def add_cruiser_and_submarine
    @computer.add_ship(@cruiser)
    @computer.add_ship(@submarine)
  end

end
