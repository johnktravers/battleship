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
    @fired_upon = true
    if @ship != nil
      @ship.hit
    end
  end

  def render(argument = nil)
    if @fired_upon == false && @ship != nil && argument == true
      "S"
    elsif @fired_upon == false
      "."
    elsif @fired_upon == true && @ship == nil
      "M"
    elsif @ship != nil && @ship.sunk?
      "X"
    elsif @fired_upon == true && @ship != nil
      "H"
    end
  end
end
