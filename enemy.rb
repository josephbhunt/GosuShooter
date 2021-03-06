require "./collidable"
require "./game_constants"

class Enemy
  include Collidable
  include GameConstants

  attr_accessor :dead, :x, :y

  MOVE_INCREMENT = 3
  POINTS = 10

  def initialize(x, y)
    @x, @y = x, y
    @image = Gosu::Image.new(ENEMY_IMAGE_FILE)
    @dead = false
  end

  def move_down
    @y += MOVE_INCREMENT
  end

  def move_left
    @x -= MOVE_INCREMENT
  end

  def move_right
    @x += MOVE_INCREMENT
  end

  def track(x, y)
    (x > @x) ? move_right : move_left
  end

  def draw
    @image.draw(@x, @y, 1)  if live?
  end

  def off_screen?
    box_points[:ru][1] > WINDOW_HEIGHT
  end

  def points
    POINTS
  end
end
