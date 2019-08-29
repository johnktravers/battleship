class Board
  attr_reader :height,
              :width,
              :all_letters,
              :all_numbers,
              :coords,
              :cells

  def initialize(height, width)
    @height = height
    @width = width
    @all_letters = ["A"]
    @all_numbers = [1]
    @coords = create_coordinates
    @cells = create_cells
  end

  def create_coordinates
    coords = []

    until @all_letters.length == @height
      @all_letters.push((@all_letters.last.ord + 1).chr)
    end

    until @all_numbers.length == @width
      @all_numbers.push(@all_numbers.last + 1)
    end

    @all_letters.each do |letter|
      @all_numbers.each do |number|
        coords.push(letter + number.to_s)
      end
    end

    coords
  end

  def create_cells
    cells = {}

    create_coordinates.each do |coord|
      cells[coord] = Cell.new(coord)
    end

    cells
  end

  def valid_coordinate?(coordinate)
    if @coords.include?(coordinate)
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
    if @width > 9
      space = "  "
      spaced_nums = @all_numbers.map do |num|
        if num <= 9
          " " + num.to_s
        else
          num
        end
      end

      line_nums = space + spaced_nums.join(" ") + " \n"
      board_length = line_nums.length
    else
      space = " "
      line_nums = "  " + @all_numbers.join(" ") + " \n"
    end

    render_array = []
    render_chars(reveal_ship).each_slice(@width) do |row|
      render_array.push(row.push("\n"))
    end

    # render_array[0] = [".", ".", ".", ".", "\n"]

    render_rows = []
    @all_letters.each_with_index do |letter, index|
      render_rows.push(letter + space + render_array[index].join(space))
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
      coordinate[1]
    end
  end

  def get_coord_letters(array_of_coords)
    array_of_coords.map do |coordinate|
      coordinate[0]
    end
  end

  def consecutive_numbers?(array_of_coords)
    @all_numbers.join.include?(get_coord_numbers(array_of_coords).join)
  end

  def consecutive_letters?(array_of_coords)
    @all_letters.join.include?(get_coord_letters(array_of_coords).join)
  end

  def coordinates_empty?(array_of_coords)
    array_of_coords.each do |coordinate|
      if !@cells[coordinate].empty?
        return false
      end
    end
    true
  end

  def render_chars(reveal_ship = false)
    sorted_coords = @coords
    render_chars = []

    @all_letters.each do |letter|
      sorted_coords.each do |coord|
        if letter == coord[0]
          render_chars.push(@cells[coord].render(reveal_ship))
        end
      end
    end
    render_chars
  end
end
