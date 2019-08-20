require './lib/ship'
require 'minitest/autorun'
require 'minitest/pride'

class ShipTest < Minitest::Test

  def setup
    @ship = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, @ship
  end

  def test_it_attributes
    assert_equal "Cruiser", @ship.name
    assert_equal 3, @ship.length
  end

  def test_health_starts_as_length_of_ship
    assert_equal 3, @ship.health
  end

  def test_it_starts_not_sunk
    assert_equal false, @ship.sunk?
  end

  def test_hit_decreases_health_by_1
    @ship.hit

    assert_equal 2, @ship.health

    @ship.hit

    assert_equal 1, @ship.health

    @ship.hit

    assert_equal 0, @ship.health
  end

  def test_ship_is_sunk_after_3_hits
    @ship.hit

    assert_equal false, @ship.sunk?

    @ship.hit

    assert_equal false, @ship.sunk?

    @ship.hit

    assert_equal true, @ship.sunk?
  end
end
