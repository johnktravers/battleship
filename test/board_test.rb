require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new(4, 4)

    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)

    @cell_1 = @board.cells["A1"]
    @cell_2 = @board.cells["A2"]
    @cell_3 = @board.cells["A3"]
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_attributes
    assert_equal 4, @board.height
    assert_equal 4, @board.width
    assert_equal ["A", "B", "C", "D"], @board.all_letters
    assert_equal [1, 2, 3, 4], @board.all_numbers
  end

  def test_it_has_coordinates
    expected = ["A1", "A2", "A3", "A4",
                "B1", "B2", "B3", "B4",
                "C1", "C2", "C3", "C4",
                "D1", "D2", "D3", "D4"]
    assert_equal expected, @board.coords
  end

  def test_it_has_cells
    assert_equal 16, @board.cells.length

    @board.cells.each_value do |cell|
      assert_instance_of Cell, cell
    end
  end

  def test_its_cells_have_valid_coordinates
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("E1")
    assert_equal false, @board.valid_coordinate?("A22")
  end

  def test_length_of_arrary_matches_ship_length
    assert_equal false, @board.length_matches?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.length_matches?(@submarine, ["A2", "A3", "A4"])
    assert_equal true, @board.length_matches?(@submarine, ["A3", "A4"])
  end

  def test_all_coordinates_in_arrary_are_valid
    assert_equal false, @board.valid_coordinates?(["A4", "A5"])
    assert_equal true, @board.valid_coordinates?(["B2", "B3", "B4"])
  end

  def test_coordinate_numbers_can_be_extracted_into_an_array
    assert_equal ["1", "1", "1"], @board.get_coord_numbers(["B1", "C1", "D1"])
    assert_equal ["2", "3", "4"], @board.get_coord_numbers(["D2", "D3", "D4"])
  end

  def test_coordinate_letters_can_be_extracted_into_an_array
    assert_equal ["C", "C", "C"], @board.get_coord_letters(["C1", "C2", "C3"])
    assert_equal ["B", "C", "D"], @board.get_coord_letters(["B3", "C3", "D3"])
  end

  def test_it_can_determine_if_coordinate_numbers_are_consecutive
    assert_equal false, @board.consecutive_numbers?(["B1", "C1", "D1"])
    assert_equal true, @board.consecutive_numbers?(["D2", "D3", "D4"])
  end

  def test_it_can_determine_if_coordinate_letters_are_consecutive
    assert_equal false, @board.consecutive_letters?(["C1", "C2", "C3"])
    assert_equal true, @board.consecutive_letters?(["B3", "C3", "D3"])
  end

  def test_coordinates_are_consecutive
    assert_equal false, @board.consecutive_coords?(["A1", "A2", "A4"])
    assert_equal true, @board.consecutive_coords?(["C2", "D2"])
  end

  def test_coordinates_cannot_be_diagonal
    assert_equal false, @board.consecutive_coords?(["A1", "B2", "C3"])
    assert_equal false, @board.consecutive_coords?(["C2", "D3"])
  end

  def test_all_coordinates_in_array_are_empty
    assert_equal true, @board.coordinates_empty?(["B1", "C1", "D1"])

    @board.place(@submarine, ["D1", "D2"])
    assert_equal false, @board.coordinates_empty?(["B1", "C1", "D1"])
  end

  def test_it_can_verify_if_ship_placement_is_valid
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "A2"])
    assert_equal true, @board.valid_placement?(@cruiser, ["B1", "C1", "D1"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "A2", "A3"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "C1"])
    assert_equal false, @board.valid_placement?(@cruiser, ["D3", "D4", "D5"])
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
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

  def test_it_can_create_an_array_of_rendered_cells
    expected = Array.new(16, ".")

    assert_equal expected, @board.render_chars

    @board.place(@cruiser, ["C2", "C3", "C4"])
    expected[9..11] = ["S", "S", "S"]

    assert_equal expected, @board.render_chars(true)
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

  def test_game_play_with_integration_test
    @board.place(@cruiser, ["C2", "C3", "C4"])
    @board.place(@submarine, ["C1", "D1"])
    expected = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    assert_equal expected, @board.render

    @board.cells["A4"].fire_upon
    expected = "  1 2 3 4 \nA . . . M \nB . . . . \nC . . . . \nD . . . . \n"
    assert_equal expected, @board.render

    @board.cells["C1"].fire_upon
    expected = "  1 2 3 4 \nA . . . M \nB . . . . \nC H . . . \nD . . . . \n"
    assert_equal expected, @board.render

    @board.cells["D1"].fire_upon
    expected = "  1 2 3 4 \nA . . . M \nB . . . . \nC X . . . \nD X . . . \n"
    assert_equal expected, @board.render

    @board.cells["C4"].fire_upon
    expected = "  1 2 3 4 \nA . . . M \nB . . . . \nC X . . H \nD X . . . \n"
    assert_equal expected, @board.render

    @board.cells["C4"].fire_upon
    expected = "  1 2 3 4 \nA . . . M \nB . . . . \nC X S S H \nD X . . . \n"
    assert_equal expected, @board.render(true)
  end

  def test_it_can_be_bigger_than_4x4
    board = Board.new(26, 26)

    assert_equal 676, board.cells.count
  end

  def test_it_can_be_smaller_than_4x4
    board = Board.new(1, 1)

    assert_equal 1, board.cells.count
    assert_instance_of Cell, board.cells["A1"]
  end

end
