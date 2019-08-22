require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new

    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)

    @cell_1 = @board.cells["A1"]
    @cell_2 = @board.cells["A2"]
    @cell_3 = @board.cells["A3"]
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_cells
    assert_equal 16, @board.cells.length

    @board.cells.each do |coordinate, cell|
      assert_instance_of Cell, cell
    end
  end

  def test_its_cells_have_valid_coordinates
    # assert_equal true, @board.valid_coordinate?("A1")
    # assert_equal true, @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_valid_ship_placement_based_on_length
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@submarine, ["A2", "A3", "A4"])
    assert_equal true, @board.valid_placement?(@submarine, ["A3", "A4"])
  end

  def test_coordinate_validity_for_ship_placement
    assert_equal false, @board.valid_placement?(@submarine, ["A4", "A5"])
    assert_equal true, @board.valid_placement?(@cruiser, ["B2", "B3", "B4"])
  end

  def test_coordinates_are_consecutive
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2", "A4"])
  end

  def test_coordinates_cannot_be_diagonal
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "B2", "C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["C2", "D3"])
  end

  def test_valid_coordinates_are_indeed_valid
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
    assert_equal true, @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
  end

  def test_ship_can_be_placed_on_board
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal @cruiser, @cell_1.ship
    assert_equal @cruiser, @cell_2.ship
    assert_equal @cruiser, @cell_3.ship
  end

  def test_two_cells_can_have_same_ship
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert @cell_3.ship == @cell_2.ship
  end

  def test_ships_cannot_overlap
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_equal false, @board.valid_placement?(@submarine, ["A1", "B1"])
  end

  def test_it_renders_as_dots_without_ships_revealed
    @board.place(@cruiser, ["A1", "A2", "A3"])

    expected = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    assert_equal expected, @board.render
  end

  def test_it_renders_as_S_when_cell_has_ship_and_ship_is_revealed
    @board.place(@cruiser, ["A1", "A2", "A3"])

    expected = "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"
    assert_equal expected, @board.render(true)
  end

end
