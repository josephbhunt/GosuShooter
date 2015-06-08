require "./collidable"
require "./game_constants"

class Enemy
  include Collidable
  include GameConstants

  attr_accessor :dead

  MOVE_INCREMENT = 3
  POINTS = 10

  def initialize(x, y)
    @x, @y = x, y
    @angle = 0
    @image = Gosu::Image.new("enemy.png")
    @dead = false
  end

  def move_down
    @y += MOVE_INCREMENT
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)  if live?
  end

  def off_screen?
    box_points[:ru][1] > WINDOW_HEIGHT
  end

  def points
    POINTS
  end
end
