
class FauxRenderer
  attr_reader :atlas

  # @param atlas [Atlas] The atlas object containing the layers and image data.
  def initialize(atlas)
    @atlas = atlas
  end

  # Renders the floor tiles based on the offsets provided.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  def render_floor(offsets)
    floor_tiles = @atlas.layers[:Floor].tiles
    to_render = []

    floor_tiles.each do |key, value|
      tile_hash = value.render
      tile_hash[:x] += offsets[:x]
      tile_hash[:y] += offsets[:y]
      to_render << tile_hash
    end

    to_render
  end

  # Renders the ceiling tiles based on the offsets provided.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  def render_ceiling(offsets)
    ceiling_tiles = @atlas.layers[:Ceiling].tiles
    to_render = []

    ceiling_tiles.each do |key, value|
      tile_hash = value.render
      tile_hash[:x] += offsets[:x]
      tile_hash[:y] += offsets[:y]
      to_render << tile_hash
    end

    to_render
  end

  # Checks if the given position is a wall in the map.
  # @param position [Hash] The position to check, containing x and y coordinates.
  # @param map [Array<String>] The game map.
  def is_wall?(position, map)
    x = position[:x]
    y = position[:y]
    return true unless map[y] && x >= 0 && x < map[y].size
    map[y][x] == MAP::WALL
  end


  # Renders the walls based on the offsets, game map, and player position.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  # @param game_map [Array<String>] The game map.
  # @param player [Hash] The player object containing x, y, and orientation.
  def render_walls(offsets, game_map, player)
    to_render = []
    to_render.concat case player.orientation % 4
                     when ORIENTATION::NORTH then render_view_north(offsets, game_map, player)
                     when ORIENTATION::EAST then render_view_east(offsets, game_map, player)
                     when ORIENTATION::SOUTH then render_view_south(offsets, game_map, player)
                     when ORIENTATION::WEST then render_view_west(offsets, game_map, player)
                     end

    to_render
  end

  private

  # Renders the walls for the north orientation.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  # @param game_map [Array<String>] The game map.
  # @param player [Hash] The player object containing x, y, and orientation.
  def render_view_north(offsets, game_map, player)
    to_render = []

    # render front wall z=-3
    [[-3, -3], [-2, -3], [-1, -3], [0, -3], [1, -3], [2, -3], [3, -3]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-3", offsets, x_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-2
    [[-2, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[-1, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-2
    [[2, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[1, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render front wall z=-2
    [[-2, -2], [-1, -2], [0, -2], [1, -2], [2, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-2", offsets, x_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-1
    [[-1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-1
    [[1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render front wall z=-1
    [[-1,-1], [0, -1], [1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-1", offsets, x_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=0
    [[-1, 0]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render right side wall z=0
    [[1, 0]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    to_render
  end

  # Renders the walls for the south orientation.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  # @param game_map [Array<String>] The game map.
  # @param player [Hash] The player object containing x, y, and orientation.
  def render_view_south(offsets, game_map, player)
    to_render = []

    # render front wall z=-3
    [[-3, 3], [-2, 3], [-1, 3], [0, 3], [1, 3], [2, 3], [3, 3]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-3", offsets, -x_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-2
    [[2, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[1, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-2
    [[-2, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[-1, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render front wall z=-2
    [[-2, 2], [-1, 2], [0, 2], [1, 2], [2, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-2", offsets, -x_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-1
    [[1, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-1
    [[-1, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render front wall z=-1
    [[-1,1], [0, 1], [1, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-1", offsets, -x_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=0
    [[1, 0]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render right side wall z=0
    [[-1, 0]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    to_render
  end

  # Renders the walls for the east orientation.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  # @param game_map [Array<String>] The game map.
  # @param player [Hash] The player object containing x, y, and orientation.
  def render_view_east(offsets, game_map, player)
    to_render = []

    # render front wall z=-3
    [[3, -3], [3, -2], [3, -1], [3, 0], [3, 1], [3, 2], [3, 3]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-3", offsets, z_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-2
    [[2, -2]].each do |x_offset, z_offset|
      # [[-2, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[2, -1]].each do |x_offset, z_offset|
      # [[-1, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-2
    [[2, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[2, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render front wall z=-2
    [[2, -2], [2, -1], [2, 0], [2, 1], [2, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-2", offsets, z_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-1
    [[1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-1
    [[1, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render front wall z=-1
    [[1,1], [1, 0], [1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-1", offsets, z_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=0
    [[0, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render right side wall z=0
    [[0, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    to_render
  end

  # Renders the walls for the west orientation.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  # @param game_map [Array<String>] The game map.
  # @param player [Hash] The player object containing x, y, and orientation.
  def render_view_west(offsets, game_map, player)
    to_render = []

    # # render front wall z=-3
    [[-3, -3], [-3, -2], [-3, -1], [-3, 0], [-3, 1], [-3, 2], [-3, 3]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-3", offsets, -z_offset) if is_wall?(new_position, game_map)
    end

    # # render left side wall z=-2
    [[-2, 2]].each do |x_offset, z_offset|
      # [[-2, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[-2, 1]].each do |x_offset, z_offset|
      # [[-1, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-2
    [[-2, -2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_2_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    [[-2, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-2", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render front wall z=-2
    [[-2, -2], [-2, -1], [-2, 0], [-2, 1], [-2, 2]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-2", offsets, -z_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=-1
    [[-1, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end
    # render right side wall z=-1
    [[-1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_-1", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render front wall z=-1
    [[-1,1], [-1, 0], [-1, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("front_0_-1", offsets, -z_offset) if is_wall?(new_position, game_map)
    end

    # render left side wall z=0
    [[0, 1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_-1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    # render right side wall z=0
    [[0, -1]].each do |x_offset, z_offset|
      new_position = { x: player[:x] + x_offset, y: player[:y] + z_offset }
      to_render << wall_from_key("side_1_0", offsets, 0) if is_wall?(new_position, game_map)
    end

    to_render
  end

  # Generates a wall hash from the key and offsets.
  # @param key [String] The key for the wall tile.
  # @param offsets [Hash] The offsets for the x and y coordinates.
  # @param x_layer_offset [Integer] The x layer offset for the wall.
  # @return [Hash] The wall hash with adjusted coordinates.
  def wall_from_key(key, offsets, x_layer_offset)
    walls = @atlas.layers[:Walls].tiles
    wall = walls[key].render.dup
    wall[:x] += wall[:w] * x_layer_offset +  offsets[:x]
    wall[:y] += offsets[:y]
    wall
  end
end

$gtk.reset
