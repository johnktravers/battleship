require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/game'
require './lib/computer'

cruiser = Ship.new("Cruiser", 3)
submarine = Ship.new("Submarine", 2)
board = Board.new
player = Player.new(board)

player.add_ship(cruiser)
player.add_ship(submarine)

player.present_board
