class BackgroundImage
  include GameConstants

  attr_accessor :image, :x, :y

  def initialize(image, x=0, y=0)
    @x, @y, @image = x, y, image
  end

  def move_down(rate=1)
    @y += rate
  end

  def move_to_top
    @y = -@image.height
  end

  def draw
    image.draw(@x, @y, 0)
  end
end
