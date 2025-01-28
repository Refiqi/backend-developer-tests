require './base_player.rb'

class YourPlayer < BasePlayer
  def initialize(game:, name:)
    super(game: game, name: name)
    @visited = {}
    @stack = []
    @current_position = nil
  end

  def next_point(time:)
    if @current_position.nil?
      # Start at the bottom-left corner
      @current_position = { row: 0, col: 0 }
      @stack.push(@current_position)
      @visited[@current_position] = true
      return @current_position
    end

    # Get the current position
    current = @current_position

    # Find all unvisited neighbors
    neighbors = [
      { row: current[:row] - 1, col: current[:col] }, # Up
      { row: current[:row] + 1, col: current[:col] }, # Down
      { row: current[:row], col: current[:col] - 1 }, # Left
      { row: current[:row], col: current[:col] + 1 }  # Right
    ].select do |neighbor|
      game.grid.is_valid_move?(from: current, to: neighbor) && !@visited[neighbor]
    end

    if neighbors.any?
      # Move to the first unvisited neighbor
      next_pos = neighbors.first
      @stack.push(next_pos)
      @visited[next_pos] = true
      @current_position = next_pos
      return next_pos
    else
      # Backtrack if no unvisited neighbors
      @stack.pop
      if @stack.any?
        @current_position = @stack.last
        return @current_position
      else
        # All nodes visited
        return @current_position
      end
    end
  end
end