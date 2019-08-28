class Player
  attr_reader :player_board,
              :player_ships,
              :shot_coords

  def initialize(computer_board, player_board, player_ships)
    @computer_board = computer_board
    @player_board = player_board
    @player_ships = player_ships
    @shot_coords = []
  end

  def present_board
    @player_ships.each do |ship|
      message = "Enter the squares for the #{ship.name} (#{ship.length} spaces):\n" +
                "To reorganize your ships, enter r.\n> "
      print @player_board.render(true) + "\n" + message

      answer = gets.chomp
      print "\n"

      if answer.downcase == "r"
        system "clear"
        @player_board = Board.new
        present_board
      end

      coords = answer.upcase.split

      loop do
        if @player_board.valid_placement?(ship, coords)
          @player_board.place(ship, coords)
          system "clear"
          break
        else
          print "Those are invalid coordinates. Please try again:\n> "
          coords = gets.chomp.upcase.split
          print "\n"
        end
      end
    end
    system "clear"
    @player_board
  end

  def fire_upon_coord
    print "Enter the coordinate for your shot:\n> "
    coord = gets.chomp.upcase
    print "\n"

    loop do
      if @computer_board.valid_coordinate?(coord)
        if !@shot_coords.include?(coord)
          @computer_board.cells[coord].fire_upon
          @shot_coords.push(coord)
          system "clear"
          display_result(coord)
          break
        else
          print "That coordinate has already been fired upon.\n" +
                "Please enter a different coordinate:\n> "
          coord = gets.chomp.upcase
          print "\n"
        end
      else
        print "Please enter a valid coordinate:\n> "
        coord = gets.chomp.upcase
        print "\n"
      end
    end
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
