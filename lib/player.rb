class Player
  attr_reader :computer_board, :player_board, :computer_ships, :player_ships

  def initialize(computer_board, player_board)
    @computer_board = computer_board
    @player_board = player_board
    @player_ships = []
    @computer_ships = []
    @shot_coords = []
  end

  def add_computer_ship(ship)
    @computer_ships.push(ship)
  end

  def add_player_ship(ship)
    @player_ships.push(ship)
  end

  def present_board
    @player_ships.each do |ship|
      message = "Enter the squares for the #{ship.name} (#{ship.length} spaces):\n> "
      print @player_board.render(true) + message
      coords = gets.chomp.split
      loop do
        if @player_board.valid_placement?(ship, coords)
          @player_board.place(ship, coords)
          break
        else
          print "Those are invalid coordinates. Please try again:\n> "
          coords = gets.chomp.split
        end
      end
      print "\n"
    end
  end

  def fire_upon_coord
    print "Enter the coordinate for your shot:\n> "
    coord = gets.chomp
    loop do
      if @computer_board.valid_coordinate?(coord)
        if !@shot_coords.include?(coord)
          @computer_board.cells[coord].fire_upon
          @shot_coords.push(coord)
          display_result(coord)
          break
        else
          print "That coordinate has already been fired upon.\n" +
                "Please enter a different coordinate:\n> "
          coord = gets.chomp
        end
      else
        print "Please enter a valid coordinate:\n> "
        coord = gets.chomp
      end
    end
    print "\n"
  end

  # Helper method

  def display_result(coord)
    if @computer_board.cells[coord].render == "M"
      print "Your shot on #{coord} was a miss.\n"
    elsif @computer_board.cells[coord].render == "H"
      print "Your shot on #{coord} was a hit.\n"
    else
      print "Your shot on #{coord} sunk my #{@computer_board.cells[coord].ship.name}!\n"
    end
  end

end
