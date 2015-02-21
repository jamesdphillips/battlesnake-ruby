module Utils

  class << self
    def find_direction(state, game)
      move_score = 0
      last_move = game.last_move || "up"
      our_snake = state.snakes.detect { |snake| snake == 'Hordor'  }

      valid = ['up', 'down', 'left', 'right'].select do |direction|
        if is_opposite?(last_move, direction)
          false
        elsif is_wall?(direction, snake, game)
          false
        elsif has_snake?(direction, snake, game)
          false
        end

        true
      end

      valid.first
    end

    def project_location(direction, coord)
      next_pos = coord.dup

      case direction
      when 'up'
        next_pos.second -= 1
      when 'down'
        next_pos.second += 1
      when 'left'
        next_pos.first -= 1
      when 'right'
        next_pos.first += 1
      end

      next_post
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

    def has_snake?(direction, snake, game)
      head = snake.coords.first
      next_pos = project_location(direction, head)
      snake_coords = game.snakes.map(&:coords).flatten
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

class Game
  
end

class Snake

end
end
