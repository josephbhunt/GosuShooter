require "./collidable"

class Item
  include Collidable
  
  def initialize(x, y)
    @x, @y = x, y
    @image = Gosu::Image.new("item.png")
  end

  def draw
    @image.draw(@x, @y, 1)  if live?
  end

end
