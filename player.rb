require "./game_constants"
require "./collidable"
require "./shot"
require "./shot_stream"

class Player
  include GameConstants
  include Collidable

  attr_accessor :shots, :score, :x, :y, :stars

  MOVE_INCREMENT = 5

  def initialize(x=0, y=0)
    @last_shot = Time.now.to_f
    @image = Gosu::Image.new("spaceship1.png")
    @x = x
    @y = y
    @vel_x = @vel_y = @angle = 0.0
    @shots = []
    @dead = false
    @score = 0
    @stars = 0
  end

  def move_left
    @x -= MOVE_INCREMENT
    @x %= WINDOW_WIDTH
  end

  def move_right
    @x += MOVE_INCREMENT
    @x %= WINDOW_WIDTH
  end

  def move_up
    @y -= MOVE_INCREMENT
    @y %= WINDOW_WIDTH
  end

  def move_down
    @y += MOVE_INCREMENT
    @y %= WINDOW_WIDTH
  end

  def shoot
    if (Time.now.to_f - @last_shot) > Shot::DELAY
      shot_y = @y - (@image.height / 2)
      @shots << Shot.new(@x, shot_y)
      @last_shot = Time.now.to_f
    end
  end

  def shoot_stream
    shot_y = @y - (@image.height / 2)
    @shots << ShotStream.new(@x, shot_y)
  end

  def stop_shot(s)
    @shots.delete(s)
  end

  def draw
    if live?
      @image.draw_rot(@x, @y, 1, @angle)
      @shots.each(&:move_up).each(&:draw)
    end
  end

  def add_to_score(points)
    @score += points
  end

  def collect_star
    @stars += 1
  end

end
