require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/game'
require './lib/computer'

computer_cruiser = Ship.new("Cruiser", 3)
computer_submarine = Ship.new("Submarine", 2)
player_cruiser = Ship.new("Cruiser", 3)
player_submarine = Ship.new("Submarine", 2)

player_board = Board.new
computer_board = Board.new

computer = Computer.new(computer_board, player_board)
player = Player.new(computer_board, player_board)
game = Game.new(computer_board, player_board)

game.main_menu

# Computer setup
computer.add_computer_ship(computer_cruiser)
computer.add_computer_ship(computer_submarine)
computer.place_ships
computer.prompt_player

# Player setup
player.add_player_ship(player_cruiser)
player.add_player_ship(player_submarine)

player.present_board

# Provide access to opponents' ships
computer.add_player_ship(player_cruiser)
computer.add_player_ship(player_submarine)
player.add_computer_ship(computer_cruiser)
player.add_computer_ship(computer_submarine)

until computer_board.render.count("X") == 5 || player_board.render.count("X") == 5
  game.display_boards

  player.fire_upon_coord
  computer.fire_upon_coord
end

game.display_boards

game.game_over

game.main_menu
