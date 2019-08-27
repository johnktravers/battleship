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
      if @ship
        @ship.hit
      end
    end
  end

  def render(reveal_ship = false)
    if !@fired_upon
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
  end
  
end
