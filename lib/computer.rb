class Computer
  attr_reader :computer_board, :player_board, :computer_ships, :player_ships

  def initialize(computer_board, player_board)
    @computer_board = computer_board
    @player_board = player_board
    @computer_ships = []
    @player_ships = []
    @shot_coords = []
  end

  def add_computer_ship(ship)
    @computer_ships.push(ship)
  end

  def add_player_ship(ship)
    @player_ships.push(ship)
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
      @computer_board.place(ship, create_random_coord_array(ship))
    end
  end

  def prompt_player
    nums = { 2 => "two", 3 => "three"}

    message = "I have laid out my ships on the grid.\n" +
              "You now need to lay out your #{nums[@player_ships.length]} ships:\n"

    @player_ships.each do |ship|
      message.concat("  The #{ship.name} is #{nums[ship.length]} units long.\n")
    end
    print message
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
  end

end
