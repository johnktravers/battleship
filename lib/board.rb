class Board
  attr_reader :cells

  def initialize
    @cells = {
              "A1" => Cell.new("A1"),
              "A2" => Cell.new("A2"),
              "A3" => Cell.new("A3"),
              "A4" => Cell.new("A4"),
              "B1" => Cell.new("B1"),
              "B2" => Cell.new("B2"),
              "B3" => Cell.new("B3"),
              "B4" => Cell.new("B4"),
              "C1" => Cell.new("C1"),
              "C2" => Cell.new("C2"),
              "C3" => Cell.new("C3"),
              "C4" => Cell.new("C4"),
              "D1" => Cell.new("D1"),
              "D2" => Cell.new("D2"),
              "D3" => Cell.new("D3"),
              "D4" => Cell.new("D4"),
              }
  end

  def valid_coordinate?(coordinate)
    if @cells[coordinate]
      true
    else
      false
    end
  end

  def valid_placement?(ship, array_of_coords)
    array_of_coords.each do |coordinate|
      if !valid_coordinate?(coordinate)
        return false
      end
    end

    all_letters = "ABCD"
    all_numbers = "1234"
    letters = []
    numbers = []

    array_of_coords.each do |coordinate|
      split = coordinate.split("")
      letters.push(split[0])
      numbers.push(split[1])
    end

    # All column arrangements are valid
    if letters.uniq.length == 1 && all_numbers.include?(numbers.join)
      true
    # All row arrangements are valid
    elsif numbers.uniq.length == 1 && all_letters.include?(letters.join)
      true
    else
      return false
    end

    ship.length == array_of_coords.length
  end

end
