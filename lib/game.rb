class Game
  attr_reader :computer_board,
              :player_board,
              :computer_ships,
              :player_ships

  def initialize
    @computer_board = nil
    @player_board = nil
    @computer_ships = []
    @player_ships = []
    @ships = [["Cruiser", 3], ["Submarine", 2]]
  end

  def main_menu
    system "clear"
    print "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.\n> "

    input = gets.chomp
    loop do
      if input == "p"
        break
      elsif input == "q"
        abort
      else
        print "Please enter either p or q to continue.\n> "
        input = gets.chomp
      end
    end
    system "clear"
  end

  def customize_fleet
    system "clear"
    message = "The board contains these ships:\n\n"
    @ships.each do |ship|
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
      if answer == "y" || answer == "yes"
        system "clear"
        print "Please provide a ship name and length with the following format: Cruiser, 3\n> "
        attrs = gets.chomp.split(", ")
        if attrs.length == 2 && attrs[1].to_i > 0
          name = attrs[0].capitalize
          length = attrs[1].to_i
          @ships.push([name, length])
          customize_fleet
          custom_ships
        end

      elsif answer == "n" || answer == "no"
require 'pry'; binding.pry
        exit
      else
        print "Please enter either y/yes or n/no:\n> "
        answer = gets.chomp.downcase
        print "\n"
      end
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
    if @computer_board.render.count("X") == 5 && @player_board.render.count("X") == 5
      puts "It's a tie!\n\n"
    elsif @player_board.render.count("X") == 5
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
      computer_cruiser = Ship.new("Cruiser", 3)
      computer_submarine = Ship.new("Submarine", 2)
      player_cruiser = Ship.new("Cruiser", 3)
      player_submarine = Ship.new("Submarine", 2)

      @player_board = Board.new
      @computer_board = Board.new

      computer = Computer.new(@computer_board, @player_board)
      player = Player.new(@computer_board, @player_board)

      main_menu

      # Computer setup
      computer.add_computer_ship(computer_cruiser)
      computer.add_computer_ship(computer_submarine)
      computer.place_ships

      computer.add_player_ship(player_cruiser)
      computer.add_player_ship(player_submarine)
      computer.prompt_player

      # Player setup
      player.add_player_ship(player_cruiser)
      player.add_player_ship(player_submarine)

      # Provide access to opponents' ships
      player.add_computer_ship(computer_cruiser)
      player.add_computer_ship(computer_submarine)

      player.present_board


      until @computer_board.render.count("X") == 5 || @player_board.render.count("X") == 5
        display_boards

        player.fire_upon_coord
        computer.fire_upon_coord
      end

      display_boards

      game_over
    end
  end
end
