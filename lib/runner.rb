require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/player'
require './lib/computer'
require './lib/game'
require './lib/runner_methods'
require 'numbers_and_words'
require 'pry'


loop do
  @game = Game.new

  main_menu

  get_board_dimension("height")
  get_board_dimension("width")
  height = @game.dimensions[0]
  width = @game.dimensions[1]

  custom_ships(@game.dimensions.max)
  total_ships = @game.create_ships

  computer_board = Board.new(height, width)
  player_board = Board.new(height, width)
  @game.add_boards(computer_board, player_board)

  computer = Computer.new(computer_board, total_ships)

  ships_placed = computer.place_ships

  player_ships = []
  ships_placed.each do |ship|
    player_ships.push(Ship.new(ship.name, ship.length))
  end

  player = Player.new(player_board, player_ships)
  present_board_to_player(player_board, player_ships)

  squares_occupied = ships_placed.sum { |ship| ship.length }

  until @game.computer_ships_sunk?(squares_occupied) || @game.player_ships_sunk?(squares_occupied)
    print @game.display_boards

    @game.prompt_player_shot
    # check if game is over
    computer_fire_upon_coord
  end

  @game.display_boards
  @game.game_over(squares_occupied)
end



# Helper methods
