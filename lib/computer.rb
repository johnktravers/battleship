class Computer
  attr_reader :computer_board,
              :player_board,
              :computer_ships,
              :player_ships,
              :shot_coords

  def initialize(computer_board, player_board, computer_ships, player_ships)
    @computer_board = computer_board
    @player_board = player_board
    @computer_ships = computer_ships
    @player_ships = player_ships
    @shot_coords = []
    @ships_placed = []
  end

  def select_random_coord
    @player_board.cells.keys.sample
  end

  def create_random_coord_array(ship)
    loop do
      random_array = @computer_board.cells.keys.sample(ship.length)
      if @computer_board.valid_placement?(ship, random_array)
        break random_array
      end
    end
  end

  def place_ships
    @computer_ships.each do |ship|
      if create_random_coord_array(ship) != nil
        @computer_board.place(ship, create_random_coord_array(ship))
        @ships_placed.push(ship)
      else
        break
      end
    end
    @ships_placed
  end

  def prompt_player
    nums = { 1 => "one", 2 => "two", 3 => "three", 4 => "four",
             5 => "five", 6 => "six", 7 => "seven", 8 => "eight",
             9 => "nine", 10 => "ten", 11 => "eleven", 12 => "twelve",
             13 => "thirteen", 14 => "fourteen", 15 => "fifteen",
             16 => "sixteen", 17 => "seventeen", 18 => "eighteen",
             19 => "nineteen", 20 => "twenty" }

    message = "I have laid out my ships on the grid.\n" +
              "You now need to lay out your #{nums[@player_ships.length]} ships:\n\n"

    @player_ships.each do |ship|
      message.concat("  The #{ship.name} is #{nums[ship.length]} units long.\n")
    end
    print message + "\n"
    message
  end

  def fire_upon_coord
    coord = nil

    loop do
      coord = select_random_coord
      if !@shot_coords.include?(coord)
        break
      end
    end

    @player_board.cells[coord].fire_upon
    @shot_coords.push(coord)

    if @player_board.cells[coord].render == "M"
      print "My shot on #{coord} was a miss.\n"
    elsif @player_board.cells[coord].render == "H"
      print "My shot on #{coord} was a hit.\n"
    else
      print "My shot on #{coord} sunk your #{@player_board.cells[coord].ship.name}!\n"
    end

    print "\n"
  end

end
