require "./collidable"

class Item
  include GameConstants
  include Collidable
  
  def initialize(x, y)
    @x, @y = x, y
    @image = Gosu::Image.new(ITEM_IMAGE_FILE)
  end

  def draw
    @image.draw(@x, @y, 1)  if live?
  end

end
