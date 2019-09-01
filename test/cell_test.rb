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

  def test_initialize
    assert_equal 'B4', @cell.coordinate
    assert_nil @cell.ship
    assert_equal false, @cell.fired_upon?
  end

  def test_it_starts_empty
    assert_equal true, @cell.empty?
  end

  def test_it_can_contain_a_ship
    @cell.place_ship(@cruiser)

    assert_equal @cruiser, @cell.ship
    assert_equal false, @cell.empty?
  end

  def test_firing_upon_cell_with_ship_decreases_health
    place_and_fire

    assert_equal 2, @cell.ship.health
  end

  def test_fired_upon_is_true_after_firing_on_cell
    place_and_fire

    assert_equal true, @cell.fired_upon?
  end

  def test_it_can_be_fired_upon_only_one_time
    place_and_fire
    2.times do
      @cell.fire_upon
    end

    assert_equal @cruiser.length - 1, @cell.ship.health
    assert_equal true, @cell.fired_upon?
  end

  def test_it_renders_correctly_without_ship
    assert_equal ".", @cell.render

    @cell.fire_upon

    assert_equal "M", @cell.render
    assert_equal "M", @cell.render(true)
  end

  def test_it_renders_correctly_with_ship
    @cell.place_ship(@cruiser)

    assert_equal "S", @cell.render(true)

    @cell.fire_upon

    assert_equal "H", @cell.render
    assert_equal "H", @cell.render(true)

    2.times do
      @cruiser.hit
    end

    assert_equal "X", @cell.render
    assert_equal "X", @cell.render(true)
  end


  # Helper methods

  def place_and_fire
    @cell.place_ship(@cruiser)
    @cell.fire_upon
  end

end
