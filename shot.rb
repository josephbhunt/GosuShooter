class Shot
  include Collidable

  MOVE_INCREMENT = 5
  DELAY = 0.2

  def initialize(x, y)
    @x = x
    @y = y
    @angle = 0
    @image = Gosu::Image.new("shot.png")
    @dead = false
  end

  def move_up
    @y -= MOVE_INCREMENT
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def off_screen?
    box_points[:rd][1] < 0
  end
end
