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
    @all_letters = "ABCD"
    @all_numbers = "1234"
  end

  def valid_coordinate?(coordinate)
    # @cells[coordinate]
    if @cells[coordinate]
      true
    else
      false
    end
  end

  def valid_placement?(ship, array_of_coords)
    if !length_matches?(ship, array_of_coords)
      false
    elsif !consecutive_coords?(array_of_coords)
      false
    elsif !valid_coordinates?(array_of_coords)
      false
    elsif !coordinates_empty?(array_of_coords)
      false
    else
      true
    end
  end

  def place(ship, array_of_coords)
    if valid_placement?(ship, array_of_coords)
      array_of_coords.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end

  def render(reveal_ship = false)
    line_nums = " " + @all_numbers.gsub(//, " ") + "\n"

    sorted_coords = @cells.keys.sort

    render_string = ""

    @all_letters.split("").each do |letter|
      sorted_coords.each do |coord|
        if letter == coord[0]
          render_string.concat(@cells[coord].render(reveal_ship))
        end
      end
    end

    render_array = []
    render_string.chars.each_slice(4) { |row| render_array.push(row.push("\n")) }

    # array = [".", ".", ".", ".", "\n"]

    render_rows = []

    @all_letters.chars.each_with_index do |letter, index|
      render_rows.push(letter + " " + render_array[index].join(" "))
    end

    line_nums + render_rows.join("")
  end

  # Helper methods

  def length_matches?(ship, array_of_coords)
    ship.length == array_of_coords.length
  end

  def valid_coordinates?(array_of_coords)
    array_of_coords.each do |coordinate|
      if !valid_coordinate?(coordinate)
        return false
      end
    end

    true
  end

  def consecutive_coords?(array_of_coords)
    get_coord_numbers(array_of_coords)
    get_coord_letters(array_of_coords)

    if consecutive_numbers?(array_of_coords) && get_coord_letters(array_of_coords).uniq.length == 1
      true
    elsif consecutive_letters?(array_of_coords) && get_coord_numbers(array_of_coords).uniq.length == 1
      true
    else
      false
    end
  end

  def get_coord_numbers(array_of_coords)
    array_of_coords.map do |coordinate|
      coordinate.split("")[1]
    end
  end

  def get_coord_letters(array_of_coords)
    array_of_coords.map do |coordinate|
      coordinate.split("")[0]
    end
  end

  def consecutive_numbers?(array_of_coords)
    @all_numbers.include?(get_coord_numbers(array_of_coords).join)
  end

  def consecutive_letters?(array_of_coords)
    @all_letters.include?(get_coord_letters(array_of_coords).join)
  end

  def coordinates_empty?(array_of_coords)
    array_of_coords.each do |coordinate|
      if !@cells[coordinate].empty?
        return false
      end
    end
    true
  end

end
