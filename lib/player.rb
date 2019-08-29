class Player
  attr_reader :player_board,
              :player_ships

  def initialize(player_board, player_ships)
    @player_board = player_board
    @player_ships = player_ships
    @nums = { 1 => "one", 2 => "two", 3 => "three", 4 => "four",
              5 => "five", 6 => "six", 7 => "seven", 8 => "eight",
              9 => "nine", 10 => "ten", 11 => "eleven", 12 => "twelve",
              13 => "thirteen", 14 => "fourteen", 15 => "fifteen",
              16 => "sixteen", 17 => "seventeen", 18 => "eighteen",
              19 => "nineteen", 20 => "twenty", 21 => "twenty-one",
              22 => "twenty-two", 23 => "twenty-three", 24 => "twenty-four",
              25 => "twenty-five", 26 => "twenty-six" }
  end

  def prompt_player
    message = "I have laid out my ships on the grid.\n" +
              "You now need to lay out your #{@nums[@player_ships.length]} ships:\n\n"

    @player_ships.each do |ship|
      message.concat("  The #{ship.name} is #{@nums[ship.length]} units long.\n")
    end
    print message + "\n"
  end

  def present_board
    @player_ships.each do |ship|
      prompt_player

      message = "Enter the squares for the #{ship.name} (#{ship.length} spaces):\n> "
      print @player_board.render(true) + "\n" + message

      answer = gets.chomp
      print "\n"
      coords = answer.upcase.split

      loop do
        if @player_board.valid_placement?(ship, coords)
          @player_board.place(ship, coords)
          system "clear"
          break
        else
          print "Those are invalid coordinates. Please try again:\n> "
          coords = gets.chomp.upcase.split
          print "\n"
        end
      end
    end

    system "clear"
    @player_board
  end

  def fire_upon_coord
    print "Enter the coordinate for your shot:\n> "
    coord = gets.chomp.upcase
    print "\n"

    coord
  end

end
