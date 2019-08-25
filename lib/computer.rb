class Computer
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def select_random_coord
    @board.cells.keys.sample
  end

  def create_random_coord_array(ship)

    random_array = @board.cells.keys.sort.sample(ship.length)

    until @board.valid_placement?(ship, random_array)
      random_array = @board.cells.keys.sort.sample(ship.length)
    end

    random_array
  end

end
