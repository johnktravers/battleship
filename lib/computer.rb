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
        next
      end
    end
    @ships_placed
  end

end
