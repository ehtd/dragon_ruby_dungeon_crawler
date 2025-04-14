
class Tile
  attr_reader :type, :flipped, :tile, :screen, :coords, :atlas_image, :source_x, :source_y, :source_w, :source_h, :path


  # Initializes a Tile object using the provided tile_data hash and atlas_image.
  # @param tile_data [Hash] the tile data containing information about the tile.
  # @param atlas_image [Hash] the atlas image data containing information about the image.
  def initialize(tile_data, atlas_image)
    @type        = tile_data['type']
    @flipped     = tile_data['flipped']
    @tile        = tile_data['tile']
    @screen      = tile_data['screen']
    @coords      = tile_data['coords']
    @source_w   = @coords["w"]
    @source_h   = @coords["h"]
    @source_x   = @coords["x"]
    @source_y   = atlas_image[:h] - @coords["y"] - @coords["h"]
    @path       = atlas_image[:path]
    @atlas_image = atlas_image
  end

  # Generates a render hash for the tile
  def render
    x = @screen["x"]
    x -= @source_w if @flipped
    {
      x:                  x,
      y:                  256 - @screen["y"] - @coords["h"],
      w:                  @coords["w"],
      h:                  @coords["h"],
      source_x:           @source_x,
      source_y:           @source_y,
      source_w:           @source_w,
      source_h:           @source_h,
      path:               @path,
      flip_horizontally:  @flipped,
    }
  end

  def to_s
    "Tile(type: #{@type}, flipped: #{@flipped}, tile: #{@tile}, screen: #{@screen}, coords: #{@coords})"
  end
end


class Layer
  attr_reader :on, :index, :name, :type, :id, :scale, :offset, :tiles, :atlas_image

  # Initializes a Layer object using the provided layer_data hash and atlas_image.
  # @param layer_data [Hash] the layer data containing information about the layer.
  # @param atlas_image [Hash] the atlas image data containing information about the image.
  def initialize(layer_data, atlas_image)
    @on          = layer_data['on']
    @index       = layer_data['index']
    @name        = layer_data['name']
    @type        = layer_data['type']
    @id          = layer_data['id']
    @scale       = layer_data['scale']
    @offset      = layer_data['offset']
    @atlas_image = atlas_image

    # Store tiles in a hash keyed by "#{tile.type}_#{tile.tile['x']}_#{tile.tile['z']}".
    @tiles = {}
    layer_data['tiles'].each do |tile_data|
      tile = Tile.new(tile_data, atlas_image)
      key = "#{tile.type}_#{tile.tile['x']}_#{tile.tile['z']}"
      @tiles[key] = tile
    end
  end

  def to_s
    "Layer(index: #{@index}, name: #{@name}, type: #{@type}, on: #{@on}, tiles count: #{@tiles.size})"
  end
end


class Atlas
  attr_reader :version, :generated, :resolution, :depth, :width, :layers, :atlas_image


  # Initializes an Atlas object using the provided atlas_data and atlas_image.
  # @param atlas_data [Hash] the atlas data containing information about the atlas.
  # @param atlas_image [Hash] the atlas image data containing information about the image.
  def initialize(atlas_data, atlas_image)
    @version     = atlas_data['version']
    @generated   = atlas_data['generated']
    @resolution  = atlas_data['resolution']
    @depth       = atlas_data['depth']
    @width       = atlas_data['width']
    @atlas_image = atlas_image

    @layers = {}
    atlas_data['layers'].each do |layer_data|
      key = layer_data['type'].to_sym
      @layers[key] = Layer.new(layer_data, atlas_image)
    end
  end

  def to_s
    layer_keys = @layers.keys.map(&:to_s).join(', ')
    "Atlas(version: #{@version}, generated: #{@generated}, resolution: #{@resolution}, depth: #{@depth}, width: #{@width}, layers: [#{layer_keys}], atlas_image: #{@atlas_image})"
  end
end


class AtlasMapper
  class << self

    # Reads the JSON file at the given file path using $gtk.parse_json_file and returns an Atlas object.
    # @param file_path [String] the path to the JSON file.
    # @param atlas_image [Hash] a hash with keys { "path", "w", "h" } representing the atlas image.
    def load_from_file(file_path, atlas_image)
      atlas_data = $gtk.parse_json_file(file_path)
      Atlas.new(atlas_data, atlas_image)
    end
  end
end

$gtk.reset