def main_menu
  system "clear"
  print @game.main_menu_prompt
  input = gets.chomp.downcase
  print "\n"

  loop do
    if input == "p"
      break
    elsif input == "q"
      abort
    else
      print @game.enter_p_or_q
      input = gets.chomp.downcase
      print "\n"
    end
  end
end

def get_board_dimension(dimension)
  system "clear"

  print @game.prompt_board_dimension(dimension)
  dimension = gets.chomp.to_i
  print "\n"

  loop do
    if dimension > 0 && dimension <= 26
      @game.add_board_dimension(dimension)
      break
    else
      print @game.enter_valid_dimension
      dimension = gets.chomp.to_i
      print "\n"
    end
  end
end

def custom_ships(longest_side)
  loop do
    system "clear"

    print @game.list_current_ships
    print @game.prompt_custom_ships
    answer = gets.chomp.downcase
    print "\n"

    if answer == "n" || answer == "no"
      system "clear"
      break

    elsif answer == "y" || answer == "yes"
      system "clear"
      print @game.prompt_ship_name
      ship_name = gets.chomp.capitalize
      print "\n"

      print @game.prompt_ship_length(longest_side)
      ship_length = gets.chomp.to_i
      print "\n"

      loop do
        if ship_length <= 0 || ship_length > longest_side
          print @game.enter_valid_ship_length(longest_side)
          ship_length = gets.chomp.to_i
          print "\n"
        else
          break
        end
      end

      @game.add_custom_ship(ship_name, ship_length)

    else
      print @game.enter_yes_or_no
      answer = gets.chomp.downcase
      print "\n"
    end
  end
end

def present_board_to_player(player_board, player_ships)
  system "clear"

  player_ships.each do |ship|
    print @game.prompt_ship_placement(player_ships)
    print @game.prompt_squares_for_ship(ship)

    coords = gets.chomp.upcase.split
    print "\n"

    loop do
      if player_board.valid_placement?(ship, coords)
        player_board.place(ship, coords)
        system "clear"
        break
      else
        print @game.invalid_placement
        coords = gets.chomp.upcase.split
        print "\n"
      end
    end
  end
end

def prompt_player_shot
  print @game.prompt_player_shot
  coord = gets.chomp.upcase
  print "\n"

  loop do
    if @game.computer_board.valid_coordinate?(coord)
      if !@game.player_shot_coords.include?(coord)
        @game.computer_board.cells[coord].fire_upon
        @game.player_shot_coords.push(coord)
        system "clear"
        print @game.display_player_result(coord)
        break
      else
        print @game.repeated_coordinate
        coord = gets.chomp.upcase
        print "\n"
      end
    else
      print @game.invalid_shot_coordinate
      coord = gets.chomp.upcase
      print "\n"
    end
  end
end
