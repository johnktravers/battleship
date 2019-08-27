class Player
  attr_reader :player_board,
              :player_ships

  def initialize(player_board, player_ships)
    @player_board = player_board
    @player_ships = player_ships
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

    coord
  end

end
