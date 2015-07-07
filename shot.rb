class Shot
  include Collidable
  include GameConstants

  MOVE_INCREMENT = 5
  DELAY = 0.2

  @@shots = []

  def self.all
    shots
  end

  def self.shots
    @@shots
  end

  def self.shots=(shot)
    shots << shot
  end

  def self.from(shooter)
    shots.select{|s| s.shooter == shooter}
  end

  def self.clean_up
    shots.select(&:off_screen?).each(&:die)
  end

  def self.update_all
    clean_up
    shots.each(&:move_up)
  end

  def self.kill_all
    shots.each(&:die)
  end

  def self.draw_all
    shots.each(&:draw)
  end

  attr_accessor :shooter

  def initialize(x, y, shooter)
    @x, @y, @shooter = x, y, shooter
    @image = Gosu::Image.new(SHOT_IMAGE_FILE)
    @dead = false
    @@shots << self
  end

  def move_up
    @y -= MOVE_INCREMENT
  end

  def move_down
    @y += MOVE_INCREMENT
  end

  def draw
    @image.draw(@x, @y, 1)  if live?
  end

  def off_screen?
    box_points[:rd][1] < 0
  end
end
