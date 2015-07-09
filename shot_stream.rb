class ShotStream < Shot
  FLOAT_INCREMENT = 1
  FLOAT_MAX = 4
  WIDTH = 4
  HEIGHT = 6

  def initialize(x, y, shooter)
    super(x, y, shooter)
    @x -= WIDTH
    @y += HEIGHT
    @x_org = @x
    @float_right = true
  end

  # Override
  def draw
    Gosu.draw_rect(@x, @y, WIDTH, HEIGHT, Gosu::Color::WHITE, 1)
    float_stream
  end

  def float_stream
    if @float_right && (@x - @x_org) > FLOAT_MAX
      @x -= FLOAT_INCREMENT
      @float_right = false
    elsif !@float_right && (@x_org - @x) > FLOAT_MAX
      @x += FLOAT_INCREMENT
      @float_right = true
    elsif @float_right
      @x += FLOAT_INCREMENT
    else 
      @x -= FLOAT_INCREMENT
    end
  end
end
