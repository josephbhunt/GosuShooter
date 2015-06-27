# Not yet functional
# A grid tile contains an image and an x, y coordinate on a grid.
# Each grid tile is intendened to contain a portion of a larger image.

class GridTile

  attr_accessor :grid_x, :grid_y, :image_x, :image_y, :image

  def initialize(image, grid_x=nil, grid_y=nil, image_x=nil, image_y=nil)
    @grid_x, @grid_y, @image_x, @image_y, @image = grid_x, grid_y, image_x, image_y, image
  end

  def set_grid_location(x, y)
    @grid_x, @grid_y = x, y
  end

  def set_image_location(x, y)
    @image_x, @image_y = x, y
  end

  def move_down(rate=1)
    @image_y += rate
  end

  def draw
    image.draw(@image_x, @image_y, 1)  unless image.nil?
  end
end
