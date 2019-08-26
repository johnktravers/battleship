class Computer
  attr_reader :computer_board, :player_board, :ships

  def initialize(computer_board, player_board)
    @computer_board = computer_board
    @player_board = player_board
    @ships = []
  end

  def add_ship(ship)
    @ships.push(ship)
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
    @ships.each do |ship|
      @computer_board.place(ship, create_random_coord_array(ship))
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

  def fire_upon_coord
    coord = select_random_coord
    @player_board.cells[coord].fire_upon
    if @player_board.cells[coord].render == "M"
      print "My shot on #{coord} was a miss.\n"
    elsif @player_board.cells[coord].render == "H"
      print "My shot on #{coord} was a hit.\n"
    else
      print "My shot on #{coord} sunk your #{@player_board.cells[coord].ship.name}!\n"
    end
  end

end
