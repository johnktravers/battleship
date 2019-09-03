class Game
  attr_reader :computer_board,
              :player_board,
              :ship_attrs,
              :total_ships,
              :computer_shot_coords,
              :player_shot_coords,
              :dimensions,
              :longest_side

  def initialize
    @computer_board = nil
    @player_board = nil
    @ship_attrs = [["Cruiser", 3], ["Submarine", 2]]
    @total_ships = []
    @computer_shot_coords = []
    @player_shot_coords = []
    @dimensions = []
    @longest_side = nil
  end

  def main_menu_prompt
    "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.\n> "
  end

  def enter_p_or_q
    "Please enter either p or q to continue.\n> "
  end

  def prompt_board_dimension(dimension)
    "Please enter an integer between 1 and 26 for the #{dimension} of the board:\n> "
  end

  def enter_valid_dimension
    "Please enter an integer between 1 and 26:\n> "
  end

  def add_board_dimension(dimension)
    @dimensions.push(dimension)
  end

  def list_current_ships
    message = "The board contains these ships:\n\n"
    @ship_attrs.each do |ship|
      message.concat("  #{ship[0]} - #{ship[1]} units long\n")
    end
    message + "\n"
  end

  def prompt_custom_ships
    "Would you like to add an additional ship?\n> "
  end

  def enter_yes_or_no
    "Please enter either y(es) or n(o):\n> "
  end

  def prompt_ship_name
    "Please provide a ship name:\n> "
  end

  def prompt_ship_length(longest_side)
    "Please provide an integer for the ship's length between 1 and #{longest_side}:\n> "
  end

  def enter_valid_ship_length(longest_side)
    "Please try again with a valid length (1 - #{longest_side}):\n> "
  end

  def add_custom_ship(name, length)
    @ship_attrs.push([name.capitalize, length])
  end

  def create_ships
    @ship_attrs.each do |ship|
      @total_ships.push(Ship.new(ship[0], ship[1]))
    end
    @total_ships
  end

  def add_boards(computer_board, player_board)
    @computer_board = computer_board
    @player_board = player_board
  end

  def prompt_ship_placement(player_ships)
    message = "I have laid out my ships on the grid.\n" +
              "You now need to lay out your #{player_ships.length.to_words} ships:\n\n"

    player_ships.each do |ship|
      message.concat("  The #{ship.name} is #{ship.length.to_words} units long.\n")
    end

    message + "\n"
  end

  def prompt_squares_for_ship(ship)
    message = "Enter the squares for the #{ship.name} (#{ship.length} spaces):\n> "
    @player_board.render(true) + "\n" + message
  end

  def invalid_placement
    "Those are invalid coordinates. Please try again:\n> "
  end

  def display_boards
    num_equal_signs = [(@computer_board.render.length / (@dimensions[0] + 1) - 14) / 2 - 1, 13].max

    ("=" * num_equal_signs) + "COMPUTER BOARD" + ("=" * num_equal_signs) + "\n" +
    @computer_board.render +
    "\n" +
    ("=" * num_equal_signs) + "=PLAYER BOARD=" + ("=" * num_equal_signs) + "\n" +
    @player_board.render(true) +
    "\n"
  end

  def computer_fire_upon_coord(computer)
    coord = loop do
      coord = computer.select_random_coord
      if !@computer_shot_coords.include?(coord)
        break coord
      end
    end

    @player_board.cells[coord].fire_upon
    @computer_shot_coords.push(coord)
    display_computer_result(coord)
  end

  def display_computer_result(coord)
    if @player_board.cells[coord].render == "M"
      "My shot on #{coord} was a miss.\n\n"
    elsif @player_board.cells[coord].render == "H"
      "My shot on #{coord} was a hit.\n\n"
    else
      "My shot on #{coord} sunk your #{@player_board.cells[coord].ship.name}!\n\n"
    end
  end

  def prompt_player_shot
    "Enter the coordinate for your shot:\n> "
  end

  def repeated_coordinate
    "That coordinate has already been fired upon.\n" +
    "Please enter a different coordinate:\n> "
  end

  def invalid_shot_coordinate
    "Please enter a valid coordinate:\n> "
  end

  def display_player_result(coord)
    if @computer_board.cells[coord].render == "M"
      "Your shot on #{coord} was a miss.\n"
    elsif @computer_board.cells[coord].render == "H"
      "Your shot on #{coord} was a hit.\n"
    else
      "Your shot on #{coord} sunk my #{@computer_board.cells[coord].ship.name}!\n"
    end
  end

  def game_over(squares_occupied)
    if computer_ships_sunk?(squares_occupied) && player_ships_sunk?(squares_occupied)
      "It's a tie!\n\n"
    elsif player_ships_sunk?(squares_occupied)
      "I won!\n\n"
    else
      "You won!\n\n"
    end
  end

  def press_enter
    "Press Enter key to continue:\n> "
  end


  # Helper methods

  def computer_ships_sunk?(squares_occupied)
    @computer_board.render.count("X") == squares_occupied
  end

  def player_ships_sunk?(squares_occupied)
    @player_board.render.count("X") == squares_occupied
  end

  def longest_side
    @dimensions.max
  end

end
