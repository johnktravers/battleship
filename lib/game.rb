class Game
  attr_reader :computer_board,
              :player_board,
              :computer_ships,
              :player_ships

  def initialize
    @computer_board = nil
    @player_board = nil
    @total_ships = []
    @ship_attrs = [["Cruiser", 3], ["Submarine", 2]]
    @squares_occupied = 0
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

          elsif attrs[1].to_i <= 0 || attrs[1].to_i > 4
            print "Please try again with a valid length (1 - 4):\n> "
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
  end

  def display_boards
    print display = "=============COMPUTER BOARD=============\n" +
                    @computer_board.render +
                    "\n" +
                    "==============PLAYER BOARD==============\n" +
                    @player_board.render(true) +
                    "\n"
    display
  end

  def game_over
    if @computer_board.render.count("X") == @squares_occupied && @player_board.render.count("X") == @squares_occupied
      puts "It's a tie!\n\n"
    elsif @player_board.render.count("X") == @squares_occupied
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
      @ship_attrs = [["Cruiser", 3], ["Submarine", 2]]
      @total_ships = []

      main_menu
      custom_ships
      create_ships

      @player_board = Board.new
      @computer_board = Board.new

      computer = Computer.new(@computer_board, @player_board, @total_ships)

      ships_placed = computer.place_ships
      p ships_placed

      @player_ships = []
      ships_placed.each do |ship|
        @player_ships.push(Ship.new(ship.name, ship.length))
      end

      player = Player.new(@computer_board, @player_board, @player_ships)

      computer.prompt_player

      @player_board = player.present_board

      @squares_occupied = @player_ships.sum do |ship|
        ship.length
      end
      p @squares_occupied

      until @computer_board.render.count("X") == @squares_occupied || @player_board.render.count("X") == @squares_occupied
        display_boards

        player.fire_upon_coord
        computer.fire_upon_coord
      end

      display_boards

      game_over
    end
  end


end
