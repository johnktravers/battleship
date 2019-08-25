class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if !fired_upon?
      @fired_upon = true
      if @ship != nil
        @ship.hit
      end
    end
  end

  def render(reveal_ship = false)
    if @fired_upon == false
      if @ship && reveal_ship == true
        "S"
      else
        "."
      end
    else
      if !@ship
        "M"
      elsif @ship && @ship.sunk?
        "X"
      else
        "H"
      end
    end


    # if @fired_upon == false && @ship != nil && argument == true
    #   "S"
    # elsif @fired_upon == false
    #   "."
    # elsif @fired_upon == true && @ship == nil
    #   "M"
    # elsif @ship != nil && @ship.sunk?
    #   "X"
    # elsif @fired_upon == true && @ship != nil
    #   "H"
    # end
  end
end
