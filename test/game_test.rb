require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_main_menu_display
    expected = "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
    assert_equal expected, @game.main_menu
  end

end
