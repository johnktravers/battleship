class Player
  attr_reader :player_board,
              :player_ships

  def initialize(player_board, player_ships)
    @player_board = player_board
    @player_ships = player_ships
  end

  def fire_upon_coord
    print "Enter the coordinate for your shot:\n> "
    coord = gets.chomp.upcase
    print "\n"

    coord
  end

end
