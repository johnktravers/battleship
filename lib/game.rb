class Game
  attr_reader :computer_board, :player_board

  def initialize(computer_board, player_board)
    @computer_board = computer_board
    @player_board = player_board
  end

  def main_menu
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
  end

  def display_boards
    print display = "=============COMPUTER BOARD=============\n" +
                    @computer_board.render +
                    "==============PLAYER BOARD==============\n" +
                    @player_board.render(true)
  end
end
