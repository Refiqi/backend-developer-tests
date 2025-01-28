require './base_player.rb'

class YourPlayer < BasePlayer
  def initialize(game:, name:)
    super(game: game, name: name)
    @visited = {}
    @stack = []
    @current_position = nil
    @region = determine_region
  end

  def next_point(time:)
    if @current_position.nil?
      # Start at the bottom-left corner of the assigned region
      @current_position = { row: @region[:start_row], col: @region[:start_col] }
      @stack.push(@current_position)
      @visited[@current_position] = true
      return @current_position
    end

    # Get the current position
    current = @current_position

    # Find all unvisited neighbors within the region
    neighbors = [
      { row: current[:row] - 1, col: current[:col] }, # Up
      { row: current[:row] + 1, col: current[:col] }, # Down
      { row: current[:row], col: current[:col] - 1 }, # Left
      { row: current[:row], col: current[:col] + 1 }  # Right
    ].select do |neighbor|
      grid.is_valid_move?(from: current, to: neighbor) && !@visited[neighbor] && in_region?(neighbor)
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
        # All nodes in the region visited
        return @current_position
      end
    end
  end

  def determine_region
    # there are 2 players and divide the grid vertically
    if name == 'Refiqi'
      { start_row: 0, start_col: 0, end_row: grid.max_row, end_col: grid.max_col / 2 }
    else
      { start_row: 0, start_col: grid.max_col / 2 + 1, end_row: grid.max_row, end_col: grid.max_col }
    end
  end

  def in_region?(point)
    point[:row].between?(@region[:start_row], @region[:end_row]) &&
      point[:col].between?(@region[:start_col], @region[:end_col])
  end

  def grid
    game.grid
  end
end