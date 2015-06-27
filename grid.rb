# This is not functional yet.
# The intent of Grid is to brake the screen into a grid of squares. Then images can be assigned to the grid
# to create a background image or level environment like walls, etc.
# Each square should have a GridTile attached to it. The GridTile contains an image.
# This way the grid tiles can be assigned to different parts of the grid.

class Grid
  include GameConstants

  attr_accessor :tiles, :map

  def initialize(ordered_images)
    @tiles = ordered_images.map{|oi| GridTile.new(oi)}
    @grid_height = WINDOW_HEIGHT / TILE_SIZE + 2
    @map = Array.new(WINDOW_WIDTH / TILE_SIZE) {Array.new(WINDOW_HEIGHT / TILE_SIZE + 2)}
    
    @map.each_with_index do |row, x|
      row.each_with_index do |col, y|
        if y == 0
        elsif y > 0 && y < @grid_height - 2
          image_x = x * TILE_SIZE
          image_y = y * TILE_SIZE
          y_multiplyer = WINDOW_WIDTH / TILE_SIZE
          grid_tile = @tiles[(y * y_multiplyer + x)]
          grid_tile.set_grid_location(x, y - TILE_SIZE) 
          grid_tile.set_image_location(image_x, image_y)
          @map[x][y] = grid_tile
        else

        end
      end
    end
  end

  def draw
    map.each {|t_row| t_row.each {|t| t.draw  unless t.nil? }}
  end
end
