require './lib/ship'
require './lib/cell'
require 'minitest/autorun'
require 'minitest/pride'

class CellTest < Minitest::Test

  def setup
    @cell = Cell.new('B4')
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_cell_has_a_coordinate
    assert_equal 'B4', @cell.coordinate
  end

  def test_cell_starts_without_a_ship
    assert_nil @cell.ship
  end

  def test_cell_starts_empty
    assert_equal true, @cell.empty?
  end

  def test_it_can_contain_a_ship
    @cell.place_ship(@cruiser)

    assert_equal @cruiser, @cell.ship
  end

  def test_placed_ship_is_a_ship
    assert_instance_of Ship, @cruiser
  end

  def test_cell_with_ship_is_not_empty
    @cell.place_ship(@cruiser)

    assert_equal false, @cell.empty?
  end

  def test_it_starts_not_fired_upon
    assert_equal false, @cell.fired_upon?
  end

  def test_firing_upon_cell_with_ship_decreases_health
    @cell.place_ship(@cruiser)
    @cell.fire_upon

    assert_equal 2, @cell.ship.health
  end

  def test_fired_upon_is_true_after_firing_on_cell
    @cell.place_ship(@cruiser)
    @cell.fire_upon

    assert_equal true, @cell.fired_upon?
  end
end
