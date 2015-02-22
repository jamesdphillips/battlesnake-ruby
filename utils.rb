module Utils

  class << self
    def find_direction(state, game)
      game.moves ||= []
      game.turns ||= []
      last_move = (game.moves || []).last
      our_snake = state.snakes.detect { |snake| snake.name == 'Hordor'  }
      objective = best_pelet(our_snake, state)

      scores = ['up', 'down', 'left', 'right'].map do |direction|
        score = 0

        if is_wall?(direction, our_snake, game)
          puts "is wall?", direction
          score = -1
        elsif has_snake?(direction, our_snake, state)
          puts "snake?", direction
          score = -1
        else
          head = our_snake.coords.first
          next_pos = project_location(direction, head)
          cur_distance = pythag(head.first - objective.x, head.second - objective.y)
          next_distance = pythag(next_pos.first - objective.x, next_pos.second - objective.y)

          score += 10 if cur_distance > next_distance
        end

        puts "===\nmoves,", game.moves, "==="
        puts "===\nturns,", game.turns, "==="

        if direction != last_move
          last_turn = game.turns.last
          second_last_turn = game.turns.last(2).first
          current_turn = is_counter_clockwise?(last_move, direction) ? 'cc' : 'c'
          score -= 5 if last_turn == second_last_turn && last_turn == current_turn && score > 0
        end

        [direction, score]
      end

      puts "\n\n\nscores\n\n\n"
      puts scores, Hash[scores].inspect

      # Find the highest direction
      highest_direction = Hash[scores].sort {|a,b| a[1]<=>b[1]}.reverse.first
      highest_direction = highest_direction.try(:first) || "left"
      game.last_move = highest_direction
      game.moves = (game.moves || []) << highest_direction

      if highest_direction != last_move
        game.turns = (game.turns || []) << (is_counter_clockwise?(last_move, highest_direction) ? 'cc' : 'c')
      end

      highest_direction
    end

    def project_location(direction, coord)
      case direction
      when 'up'
        [coord.first, coord.second - 1]
      when 'down'
        [coord.first, coord.second + 1]
      when 'left'
        [coord.first - 1, coord.second]
      when 'right'
        [coord.first + 1, coord.second]
      end
    end

    def has_turned?(game)
      last_move = (game.moves || []).last
      second_last_move = (game.moves || []).last(2).first
      last_move != second_last_move
    end

    def is_clockwise?(first_move, second_move)
      !is_counter_clockwise(first_move, second_move)
    end

    def is_counter_clockwise?(first_move, second_move)
      case
      when first_move == "up" && second_move == "left"
        true
      when first_move == "left" && second_move == "down"
        true
      when first_move == "down" && second_move == "right"
        true
      when first_move == "right" && second_move == "up"
        true
      else
        false
      end
    end

    def is_wall?(direction, snake, game)
      head = snake.coords.first
      next_pos = project_location(direction, head)

      case
      when next_pos.first < 0
        true
      when next_pos.second < 0
        true
      when next_pos.first >= game.width
        true
      when next_pos.second >= game.height
        true
      else
        false
      end
    end

    def best_pelet(snake, state)
      head = snake.coords.first
      pelets = []

      state.board.each_with_index do |col, x|
        col.each_with_index do |tile, y|
          pelets << Hashie::Mash.new({ x: x, y: y }) if tile.state == 'food'
        end
      end

      distances = pelets.map do |pelet|
        x, y = head.first - pelet.x, head.second - pelet.y
        [pelet, pythag(x,y)]
      end

      Hash[distances].sort {|a,b| a[1]<=>b[1]}.first.first
    end

    def pythag(x, y)
      Math.sqrt((x * x) + (y * y))
    end

    def has_snake?(direction, snake, state)
      head = snake.coords.first
      next_pos = project_location(direction, head)
      snake_coords = state.snakes.inject([]) { |all, snake| all + snake.coords }
      snake_coords.any? { |coord| coord.first == next_pos.first && coord.second == next_pos.second }
    end

    def is_opposite?(last_move, direction)
      case
      when (last_move == 'up' || direction == 'down')
        true
      when (last_move == 'left' || direction == 'right')
        true
      when (last_move == 'down' || direction == 'up')
        true
      when (last_move == 'right' || direction == 'left')
        true
      else
        false
      end
    end
  end
end
