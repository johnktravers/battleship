class Computer
  attr_reader :computer_board,
              :total_ships,
              :ships_placed

  def initialize(computer_board, total_ships)
    @computer_board = computer_board
    @total_ships = total_ships
    @ships_placed = []
  end

  def select_random_coord
    @computer_board.cells.keys.sample
  end

  def create_random_coord_array(ship)
    100.times do
      random_coord = select_random_coord

      random_array = create_random_row(ship, random_coord)

      if @computer_board.valid_placement?(ship, random_array)
        break random_array
      end

      random_array = create_random_column(ship, random_coord)

      if @computer_board.valid_placement?(ship, random_array)
        break random_array
      end

    end
  end

  def create_random_row(ship, random_coord)
    random_array = []
    letter = random_coord[0]
    random_numbers = [random_coord[1].to_i]

    until random_numbers.length == ship.length
      random_numbers.push(random_numbers.last + 1)
    end

    random_numbers.each do |number|
      random_array.push(letter + number.to_s)
    end
    random_array
  end

  def create_random_column(ship, random_coord)
    random_array = []
    number = random_coord[1]
    random_letters = [random_coord[0]]

    until random_letters.length == ship.length
      random_letters.push((random_letters.last.ord + 1).chr)
    end

    random_letters.each do |letter|
      random_array.push(letter + number)
    end
    random_array
  end

  def place_ships
    @total_ships.each do |ship|
      coord_array = create_random_coord_array(ship)

      if coord_array != 100
        @computer_board.place(ship, coord_array)
        @ships_placed.push(ship)
      else
        return @ships_placed
      end
    end
  end

  def prompt_player
    nums = { 1 => "one", 2 => "two", 3 => "three", 4 => "four",
             5 => "five", 6 => "six", 7 => "seven", 8 => "eight",
             9 => "nine", 10 => "ten", 11 => "eleven", 12 => "twelve",
             13 => "thirteen", 14 => "fourteen", 15 => "fifteen",
             16 => "sixteen", 17 => "seventeen", 18 => "eighteen",
             19 => "nineteen", 20 => "twenty" }

    message = "I have laid out my ships on the grid.\n" +
              "You now need to lay out your #{nums[@ships_placed.length]} ships:\n\n"

    @ships_placed.each do |ship|
      message.concat("  The #{ship.name} is #{nums[ship.length]} units long.\n")
    end
    print message + "\n"
    message
  end

end
