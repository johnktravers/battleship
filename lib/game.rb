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
