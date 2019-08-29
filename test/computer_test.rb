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
    @total_ships = [@cruiser, @submarine]

    @computer_board = Board.new(4, 4)
    @computer = Computer.new(@computer_board, @total_ships)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_it_has_a_board_and_ships
    assert_equal @computer_board, @computer.computer_board
    assert_equal @total_ships, @computer.total_ships
  end

  def test_it_starts_with_no_ships_placed
    assert_equal [], @computer.ships_placed
  end

  def test_it_can_select_a_random_coordinate
    actual = @computer_board.cells.keys.include?(@computer.select_random_coord)
    assert_equal true, actual
  end

  def test_it_can_create_a_valid_row
    assert_equal ["C2", "C3", "C4"], @computer.create_random_row(@cruiser, "C2")
  end

  def test_it_can_create_a_valid_random_column
    assert_equal ["B2", "C2", "D2"], @computer.create_random_column(@cruiser, "B2")
  end

  def test_computer_picks_valid_random_coordinate_array
    cruiser_coords = @computer.create_random_coord_array(@cruiser)

    actual = @computer.computer_board.valid_placement?(@cruiser, cruiser_coords)
    assert_equal true, actual

    @computer.computer_board.place(@cruiser, cruiser_coords)
    sub_coords = @computer.create_random_coord_array(@submarine)

    actual = @computer.computer_board.valid_placement?(@submarine, sub_coords)
    assert_equal true, actual
  end

  def test_ships_can_be_placed
    @computer.place_ships

    assert_equal 5, @computer.computer_board.render(true).count("S")
    assert_equal @total_ships, @computer.ships_placed
  end

end
