require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require './lib/computer'
require 'numbers_and_words'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_initialize
    assert_nil @game.computer_board
    assert_nil @game.player_board
    assert_equal [["Cruiser", 3], ["Submarine", 2]], @game.ship_attrs
    assert_equal [], @game.total_ships
    assert_equal [], @game.computer_shot_coords
    assert_equal [], @game.player_shot_coords
    assert_equal [], @game.dimensions
    assert_nil @game.longest_side
  end

  def test_main_menu
    expected = "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.\n> "
    assert_equal expected, @game.main_menu_prompt
  end

  def test_enter_p_or_q
    expected = "Please enter either p or q to continue.\n> "
    assert_equal expected, @game.enter_p_or_q
  end

  def test_get_board_dimensions
    expected = "Please enter an integer between 1 and 26 for the height of the board:\n> "
    assert_equal expected, @game.prompt_board_dimension("height")

    expected = "Please enter an integer between 1 and 26 for the width of the board:\n> "
    assert_equal expected, @game.prompt_board_dimension("width")
  end

  def test_enter_valid_dimension
    expected = "Please enter an integer between 1 and 26:\n> "
    assert_equal expected, @game.enter_valid_dimension
  end

  def test_add_board_dimension
    add_height_5_and_width_6

    assert_equal [5, 6], @game.dimensions
  end

  def test_list_current_ships
    expected = "The board contains these ships:\n\n" +
               "  Cruiser - 3 units long\n" +
               "  Submarine - 2 units long\n\n"
    assert_equal expected, @game.list_current_ships
  end

  def test_custom_ships_prompt
    expected = "Would you like to add an additional ship?\n> "
    assert_equal expected, @game.prompt_custom_ships
  end

  def test_enter_yes_or_no
    expected = "Please enter either y(es) or n(o):\n> "
    assert_equal expected, @game.enter_yes_or_no
  end

  def test_ship_name_prompt
    expected = "Please provide a ship name:\n> "
    assert_equal expected, @game.prompt_ship_name
  end

  def test_ship_length_prompt
    add_height_5_and_width_6

    expected = "Please provide an integer for the ship's length between 1 and 6:\n> "
    assert_equal expected, @game.prompt_ship_length(@game.longest_side)
  end

  def test_enter_valid_ship_length
    add_height_5_and_width_6

    expected = "Please try again with a valid length (1 - 6):\n> "
    assert_equal expected, @game.enter_valid_ship_length(@game.longest_side)
  end

  def test_add_custom_ship
    @game.add_custom_ship("Battleship", 5)

    expected = [["Cruiser", 3], ["Submarine", 2], ["Battleship", 5]]
    assert_equal expected, @game.ship_attrs
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

  def test_add_computer_and_player_boards
    computer_board = Board.new(10, 10)
    player_board = Board.new(10, 10)
    @game.add_boards(computer_board, player_board)

    assert_equal computer_board, @game.computer_board
    assert_equal player_board, @game.player_board
  end

  def test_prompt_ship_placement
    create_cruiser_and_submarine

    expected = "I have laid out my ships on the grid.\n" +
               "You now need to lay out your two ships:\n\n" +
               "  The Cruiser is three units long.\n" +
               "  The Submarine is two units long.\n\n"
    assert_equal expected, @game.prompt_ship_placement([@cruiser, @submarine])
  end

  def test_prompt_squares_for_ship
    player_board = Board.new(4, 4)
    computer_board = Board.new(4, 4)
    @game.add_boards(computer_board, player_board)

    expected = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n" +
               "\n" +
               "Enter the squares for the Cruiser (3 spaces):\n> "
    assert_equal expected, @game.prompt_squares_for_ship(Ship.new("Cruiser", 3))
  end

  def test_invalid_placement
    expected = "Those are invalid coordinates. Please try again:\n> "
    assert_equal expected, @game.invalid_placement
  end

  def test_display_boards_with_4x4
    @game.add_board_dimension(4)
    player_board = Board.new(4, 4)
    computer_board = Board.new(4, 4)
    @game.add_boards(computer_board, player_board)

    create_cruiser_and_submarine
    player_board.place(@cruiser, ["C1", "C2", "C3"])
    player_board.place(@submarine, ["A4", "B4"])

    expected = "=============COMPUTER BOARD=============\n" +
               "  1 2 3 4 \n" +
               "A . . . . \n" +
               "B . . . . \n" +
               "C . . . . \n" +
               "D . . . . \n" +
               "\n" +
               "==============PLAYER BOARD==============\n" +
               "  1 2 3 4 \n" +
               "A . . . S \n" +
               "B . . . S \n" +
               "C S S S . \n" +
               "D . . . . \n" +
               "\n"
    assert_equal expected, @game.display_boards
  end

  def test_display_boards_with_adjusted_equal_signs
    @game.add_board_dimension(2)
    player_board = Board.new(2, 16)
    computer_board = Board.new(2, 16)
    @game.add_boards(computer_board, player_board)

    create_cruiser_and_submarine
    player_board.place(@cruiser, ["B12", "B13", "B14"])
    player_board.place(@submarine, ["A6", "B6"])

    expected = "=================COMPUTER BOARD=================\n" +
               "   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 \n" +
               "A  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  \n" +
               "B  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  \n" +
               "\n" +
               "==================PLAYER BOARD==================\n" +
               "   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 \n" +
               "A  .  .  .  .  .  S  .  .  .  .  .  .  .  .  .  .  \n" +
               "B  .  .  .  .  .  S  .  .  .  .  .  S  S  S  .  .  \n" +
               "\n"
    assert_equal expected, @game.display_boards
  end

  def test_computer_fire_upon_coord
    create_cruiser_and_submarine
    player_board = Board.new(4, 4)
    computer_board = Board.new(4, 4)
    computer = Computer.new(computer_board, [@cruiser, @submarine])
    @game.add_boards(computer_board, player_board)
    @game.computer_fire_upon_coord(computer)

    assert_equal 1, @game.computer_shot_coords.length
    assert_equal 15, @game.player_board.render.count(".")
  end

  def test_display_computer_result
    setup_game_with_submarines_on_C3_and_D3

    @game.player_board.cells["B2"].fire_upon
    expected = "My shot on B2 was a miss.\n\n"
    assert_equal expected, @game.display_computer_result("B2")

    @game.player_board.cells["D3"].fire_upon
    expected = "My shot on D3 was a hit.\n\n"
    assert_equal expected, @game.display_computer_result("D3")

    @game.player_board.cells["C3"].fire_upon
    expected = "My shot on C3 sunk your Submarine!\n\n"
    assert_equal expected, @game.display_computer_result("C3")
  end

  def test_prompt_player_shot
    expected = "Enter the coordinate for your shot:\n> "
    assert_equal expected, @game.prompt_player_shot
  end

  def test_repeated_coordinate
    expected = "That coordinate has already been fired upon.\n" +
               "Please enter a different coordinate:\n> "
    assert_equal expected, @game.repeated_coordinate
  end

  def test_invalid_shot_coordinate
    expected = "Please enter a valid coordinate:\n> "
    assert_equal expected, @game.invalid_shot_coordinate
  end

  def test_display_player_result
    setup_game_with_submarines_on_C3_and_D3

    @game.computer_board.cells["A4"].fire_upon
    expected = "Your shot on A4 was a miss.\n"
    assert_equal expected, @game.display_player_result("A4")

    @game.computer_board.cells["C3"].fire_upon
    expected = "Your shot on C3 was a hit.\n"
    assert_equal expected, @game.display_player_result("C3")

    @game.computer_board.cells["D3"].fire_upon
    expected = "Your shot on D3 sunk my Submarine!\n"
    assert_equal expected, @game.display_player_result("D3")
  end

  def test_game_over_tie_game
    setup_game_with_submarines_on_C3_and_D3

    @game.player_board.cells["C3"].fire_upon
    @game.computer_board.cells["C3"].fire_upon
    @game.player_board.cells["D3"].fire_upon
    @game.computer_board.cells["D3"].fire_upon

    assert_equal "It's a tie!\n\n", @game.game_over(2)
  end

  def test_game_over_computer_wins
    setup_game_with_submarines_on_C3_and_D3

    @game.player_board.cells["C3"].fire_upon
    @game.player_board.cells["D3"].fire_upon

    assert_equal "I won!\n\n", @game.game_over(2)
  end

  def test_game_over_player_wins
    setup_game_with_submarines_on_C3_and_D3

    @game.computer_board.cells["C3"].fire_upon
    @game.computer_board.cells["D3"].fire_upon

    assert_equal "You won!\n\n", @game.game_over(2)
  end

  def test_press_enter
    expected = "Press Enter key to continue:\n> "
    assert_equal expected, @game.press_enter
  end


  # Tests for helper methods

  def test_computer_ships_sunk
    setup_game_with_submarines_on_C3_and_D3
    assert_equal false, @game.computer_ships_sunk?(2)

    @game.computer_board.cells["C3"].fire_upon
    @game.computer_board.cells["D3"].fire_upon

    assert_equal true, @game.computer_ships_sunk?(2)
  end

  def test_player_ships_sunk
    setup_game_with_submarines_on_C3_and_D3
    assert_equal false, @game.player_ships_sunk?(2)

    @game.player_board.cells["C3"].fire_upon
    @game.player_board.cells["D3"].fire_upon

    assert_equal true, @game.player_ships_sunk?(2)
  end

  def test_longest_side
    add_height_5_and_width_6

    assert_equal 6, @game.longest_side
  end


  # Helper methods

  def add_height_5_and_width_6
    @game.add_board_dimension(5)
    @game.add_board_dimension(6)
  end

  def create_cruiser_and_submarine
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def setup_game_with_submarines_on_C3_and_D3
    @computer_submarine = Ship.new("Submarine", 2)
    @player_submarine = Ship.new("Submarine", 2)
    player_board = Board.new(4, 4)
    computer_board = Board.new(4, 4)
    @game.add_boards(computer_board, player_board)
    @game.computer_board.place(@computer_submarine, ["C3", "D3"])
    @game.player_board.place(@player_submarine, ["C3", "D3"])
  end

end
