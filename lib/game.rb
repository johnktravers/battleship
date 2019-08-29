class Game
  attr_reader :computer_board,
              :player_board,
              :ship_attrs,
              :total_ships,
              :squares_occupied,
              :computer_shot_coords,
              :player_shot_coords,
              :height,
              :width

  def initialize
    @computer_board = nil
    @player_board = nil
    @ship_attrs = [["Cruiser", 3], ["Submarine", 2]]
    @total_ships = []
    @squares_occupied = 0
    @computer_shot_coords = []
    @player_shot_coords = []
    @height = 0
    @width = 0
  end

  def main_menu
    system "clear"
    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.\n> "

    input = gets.chomp
    print "\n"

    loop do
      if input == "p"
        break
      elsif input == "q"
        abort
      else
        print "Please enter either p or q to continue.\n> "
        input = gets.chomp
        print "\n"
      end
    end
    system "clear"
  end

  def get_board_height
    system "clear"
    print "Please enter an integer for the height of the board:\n> "
    @height = gets.chomp.to_i
    print "\n"

    loop do
      if @height > 0 && @height <= 26
        break
      else
        print "Please enter an integer between 1 and 26:\n> "
        @height = gets.chomp.to_i
        print "\n"
      end
    end
  end

  def get_board_width
    print "Now enter an integer for the width of the board:\n> "
    @width = gets.chomp.to_i
    print "\n"

    loop do
      if @width > 0 && @width <= 26
        break
      else
        print "Please enter an integer between 1 and 26:\n> "
        @width = gets.chomp.to_i
        print "\n"
      end
    end
  end

  def customize_fleet
    system "clear"
    message = "The board contains these ships:\n\n"
    @ship_attrs.each do |ship|
      message.concat("  #{ship[0]} – #{ship[1]} units long\n")
    end
    print message + "\n"
  end

  def custom_ships
    customize_fleet
    print "Would you like to add an additional ship?\n> "
    answer = gets.chomp.downcase
    print "\n"

    loop do
      if answer == "n" || answer == "no"
        system "clear"
        break

      elsif answer == "y" || answer == "yes"
        system "clear"
        print "Please provide a ship name and length with the following format: Cruiser, 3\n> "
        attrs = gets.chomp.split(", ")
        print "\n"

        loop do
          if attrs.length != 2
            print "Please enter the name and length in the format: Cruiser, 3\n> "
            attrs = gets.chomp.split(", ")
            print "\n"

          elsif attrs[1].to_i <= 0 || attrs[1].to_i > longest_side
            print "Please try again with a valid length (1 - #{longest_side}):\n> "
            attrs = gets.chomp.split(", ")
            print "\n"
          else
            break
          end
        end

        name = attrs[0].capitalize
        length = attrs[1].to_i
        @ship_attrs.push([name, length])

        customize_fleet
        custom_ships
        break

      else
        print "Please enter either y/yes or n/no:\n> "
        answer = gets.chomp.downcase
        print "\n"
      end
    end
  end

  def create_ships
    @ship_attrs.each do |ship|
      @total_ships.push(Ship.new(ship[0], ship[1]))
    end
    @total_ships
  end

  def computer_fire_upon_coord
    coord = nil

    loop do
      coord = @computer.select_random_coord
      if !@computer_shot_coords.include?(coord)
        break
      end
    end

    @player_board.cells[coord].fire_upon
    @computer_shot_coords.push(coord)
    display_computer_result(coord)
  end

  def display_computer_result(coord)
    if @player_board.cells[coord].render == "M"
      print "My shot on #{coord} was a miss.\n"
    elsif @player_board.cells[coord].render == "H"
      print "My shot on #{coord} was a hit.\n"
    else
      print "My shot on #{coord} sunk your #{@player_board.cells[coord].ship.name}!\n"
    end

    print "\n"
  end

  def player_fire_upon_coord
    coord = @player.fire_upon_coord

    loop do
      if @computer_board.valid_coordinate?(coord)
        if !@player_shot_coords.include?(coord)
          @computer_board.cells[coord].fire_upon
          @player_shot_coords.push(coord)
          system "clear"
          display_player_result(coord)
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

  def display_player_result(coord)
    if @computer_board.cells[coord].render == "M"
      print "Your shot on #{coord} was a miss.\n"
    elsif @computer_board.cells[coord].render == "H"
      print "Your shot on #{coord} was a hit.\n"
    else
      print "Your shot on #{coord} sunk my #{@computer_board.cells[coord].ship.name}!\n"
    end
  end

  def display_boards
    num_equal_signs = [(@computer_board.render.length / (@height + 1) - 14) / 2 - 1, 13].max

    print ("=" * num_equal_signs) + "COMPUTER BOARD" + ("=" * num_equal_signs) + "\n" +
          @computer_board.render +
          "\n" +
          ("=" * num_equal_signs) + "=PLAYER BOARD=" + ("=" * num_equal_signs) + "\n" +
          @player_board.render(true) +
          "\n"
  end

  def game_over
    if computer_ships_sunk? && player_ships_sunk?
      puts "It's a tie!\n\n"
    elsif player_ships_sunk?
      puts "I won!\n\n"
    else
      puts "You won!\n\n"
    end

    print "Press Enter key to continue:\n> "
    gets
    system "clear"
  end

  def play
    loop do
      initialize

      main_menu
      get_board_height
      get_board_width

      custom_ships
      create_ships

      @player_board = Board.new(@height, @width)
      @computer_board = Board.new(@height, @width)

      @computer = Computer.new(@computer_board, @total_ships)

      @ships_placed = @computer.place_ships

      @player_ships = []
      @ships_placed.each do |ship|
        @player_ships.push(Ship.new(ship.name, ship.length))
      end

      @player = Player.new(@player_board, @player_ships)
      @player.present_board

      @squares_occupied = @player_ships.sum do |ship|
        ship.length
      end

      until computer_ships_sunk? || player_ships_sunk?
        display_boards

        player_fire_upon_coord
        computer_fire_upon_coord
      end

      display_boards
      game_over
    end
  end


  # Helper methods

  def computer_ships_sunk?
    @computer_board.render.count("X") == @squares_occupied
  end

  def player_ships_sunk?
    @player_board.render.count("X") == @squares_occupied
  end

  def longest_side
    if @height > @width
      @height
    else
      @width
    end
  end

end
