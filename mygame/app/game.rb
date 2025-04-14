# frozen_string_literal: true

module MAP
  WALL = '#'
  EMPTY = '.'
  PLAYER = '@'
end

module ORIENTATION
  NORTH = 0
  EAST = 1
  SOUTH = 2
  WEST = 3
end

# Game class
class Game

  attr_gtk

  def initialize
  end

  def tick
    init
    render
    input
    update

    # outputs.primitives << gtk.framerate_diagnostics_primitives
  end

  def init
    state.atlas ||= AtlasMapper.load_from_file("app/atlas_fog.json", { path: "sprites/untitled_fog.png", w: 528, h: 476 })
    state.faux_renderer ||= FauxRenderer.new(state.atlas)
    state.offset ||= { x: 480, y: 232 }
    state.map ||= [
      "############",
      "#...#..#####",
      "#...##.#####",
      "#...##.#####",
      "#.........##",
      "#...#####.##",
      "#####.....##",
      "############"
    ]
    state.player ||= {x: 2, y: 1, orientation: ORIENTATION::WEST }
  end

  def render
  end

  def input
    # --- Handle Rotation ---
    # Rotate 90° counterclockwise with Q key.
    if inputs.keyboard.key_down.q
      state.player.orientation = (state.player.orientation - 1) % 4
    end
    # Rotate 90° clockwise with E key.
    if inputs.keyboard.key_down.e
      state.player.orientation = (state.player.orientation + 1) % 4
    end

    # --- Calculate Movement Vectors Based on Orientation ---
    forward_vector = case state.player.orientation % 4
                     when ORIENTATION::NORTH then [0, -1]
                     when ORIENTATION::EAST then [1,  0]
                     when ORIENTATION::SOUTH then [0,  1]
                     when ORIENTATION::WEST then [-1, 0]
                     end

    left_vector = case state.player.orientation % 4
                  when ORIENTATION::NORTH then [-1,  0]
                  when ORIENTATION::EAST then [0, -1]
                  when ORIENTATION::SOUTH then [1,  0]
                  when ORIENTATION::WEST then [0,  1]
                  end

    # --- Handle Movement ---
    if inputs.keyboard.key_down.w
      new_x = state.player[:x] + forward_vector[0]
      new_y = state.player[:y] + forward_vector[1]
      move_player(new_x, new_y, state.map)
    end

    if inputs.keyboard.key_down.s
      new_x = state.player[:x] - forward_vector[0]
      new_y = state.player[:y] - forward_vector[1]
      move_player(new_x, new_y, state.map)
    end

    if inputs.keyboard.key_down.a
      new_x = state.player[:x] + left_vector[0]
      new_y = state.player[:y] + left_vector[1]
      move_player(new_x, new_y, state.map)
    end

    if inputs.keyboard.key_down.d
      new_x = state.player[:x] - left_vector[0]
      new_y = state.player[:y] - left_vector[1]
      move_player(new_x, new_y, state.map)
    end

    draw_grid_with_player

    # Debug labels to show state.
    orientation_names = {
      ORIENTATION::NORTH => "North",
      ORIENTATION::EAST => "East",
      ORIENTATION::SOUTH => "South",
      ORIENTATION::WEST => "West"
    }
    outputs.labels << [1000, 700, "Player Pos: (#{state.player[:x]}, #{state.player[:y]})"]
    outputs.labels << [1000, 650, "Orientation: #{orientation_names[state.player.orientation % 4]}"]

    outputs.primitives << {
      x: 0,
      y: 0,
      w: 1280,
      h: 550,
      primitive_marker: :solid }

    outputs.primitives << state.faux_renderer.render_floor(state.offset)
    outputs.primitives << state.faux_renderer.render_ceiling(state.offset)
    outputs.primitives << state.faux_renderer.render_walls(state.offset, state.map, state.player)

    outputs.primitives << {
      x: state.offset[:x],
      y: state.offset[:y],
      w: 320,
      h: 256,
      r: 255,
      primitive_marker: :border }

    outputs.primitives << {
      x: 0,
      y: 0,
      w: 480,
      h: 550,
      primitive_marker: :solid }

    outputs.primitives << {
      x: 800,
      y: 0,
      w: 480,
      h: 550,
      primitive_marker: :solid }
  end

  def update
  end

  # Move the player to a new position if the move is valid.
  # @param new_x [Integer] The new x-coordinate of the player.
  # @param new_y [Integer] The new y-coordinate of the player.
  # @param map [Array<String>] The game map.
  def move_player(new_x, new_y, map)
    if valid_move?(new_x, new_y, map)
      state.player[:x] = new_x
      state.player[:y] = new_y
    end
  end

  # Check if the move is valid.
  # A move is valid if:
  # - The new position is within the bounds of the map.
  # - The new position does not hit a wall ('#').
  # @param x [Integer] The x-coordinate to check.
  # @param y [Integer] The y-coordinate to check.
  # @param map [Array<String>] The game map.
  # @return [Boolean] True if the move is valid, false otherwise.
  def valid_move?(x, y, map)
    # Ensure there is a row at y and that x is within that row’s bounds.
    return false unless map[y] && x >= 0 && x < map[y].size
    map[y][x] != MAP::WALL
  end

  def draw_grid_with_player
    player_icon = case state.player.orientation % 4
                  when 0 then '^'
                  when 1 then '>'
                  when 2 then 'v'
                  when 3 then '<'
                  end

    temp_map = []
    state.map.each_with_index do |row, row_index|
      if row_index == state.player[:y]
        row_chars = row.chars
        row_chars[state.player[:x]] = player_icon
        temp_map << row_chars.join("")
      else
        temp_map << row
      end
    end

    # Draw the temporary map with the overlaid player.
    temp_map.each_with_index do |row, index|
      outputs.labels << [10, 720 - (index * 20), row]
    end
  end

end

$gtk.reset
