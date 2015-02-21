module Utils

  class << self
    def find_direction(state, game)
      # last_move = game.last_move || "up"
      puts "snakes", state.snakes.inspect
      our_snake = state.snakes.detect { |snake| snake.name == 'Hordor'  }

      scores = ['up', 'down', 'left', 'right'].map do |direction|
        score = 100

        #if is_opposite?(last_move, direction)
        #  [direction, 0]
        if is_wall?(direction, our_snake, game)
          [direction, 0]
        elsif has_snake?(direction, our_snake, state)
          [direction, 0]
        else
          [direction, score]
        end
      end

      puts "\n\n\nscores\n\n\n"
      puts scores, Hash[scores].inspect

      # Find the highest direction
      highest_direction = Hash[scores].sort {|a,b| a[1]<=>b[1]}.first
      highest_direction = highest_direction.try(:first) || "left"
      game.last_move = highest_direction

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
        [coord.first, coord.second - 1]
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
      when (game.width - next_pos.first) >= 0
        true
      when (game.height - next_pos.second) >= 0
        true
      end

      false
    end

    def has_snake?(direction, snake, state)
      head = snake.coords.first
      next_pos = project_location(direction, head)
      snake_coords = state.snakes.inject([]) { |all, coords| all + coords }
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
