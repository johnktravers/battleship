class Computer
  attr_reader :board, :ships

  def initialize(board)
    @board = board
    @ships = []
  end

  def add_ship(ship)
    @ships.push(ship)
  end

  def select_random_coord
    @board.cells.keys.sample
  end

  def create_random_coord_array(ship)
    loop do
      random_array = @board.cells.keys.sample(ship.length)
      if @board.valid_placement?(ship, random_array)
        break random_array
      end
    end
  end

  def place_ships
    @ships.each do |ship|
      @board.place(ship, create_random_coord_array(ship))
    end
  end

  def prompt_player
    nums = { 2 => "two", 3 => "three"}

    message = "I have laid out my ships on the grid.\n" +
              "You now need to lay out your #{nums[@ships.length]} ships:\n"

    @ships.each do |ship|
      message.concat("  The #{ship.name} is #{nums[ship.length]} units long.\n")
    end
    print message
    message
  end

end
