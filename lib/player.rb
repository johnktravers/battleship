class Player
  attr_reader :board, :ships

  def initialize(board)
    @board = board
    @ships = []
  end

  def add_ship(ship)
    @ships.push(ship)
  end

  def present_board
    @ships.each do |ship|
      message = "Enter the squares for the #{ship.name} (#{ship.length} spaces):\n> "
      print @board.render(true) + message
      coords = gets.chomp.split
      loop do
        if @board.valid_placement?(ship, coords)
          @board.place(ship, coords)
          break
        else
          print "Those are invalid coordinates. Please try again:\n> "
          coords = gets.chomp.split
        end
      end
    end
  end
end
