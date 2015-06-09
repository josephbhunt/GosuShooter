class Explosion
  ANIMATION_SPEED = 75

  def initialize(x, y, offset=25)
    @x, @y = (x - offset), (y - offset)
    @frame_start_time = Gosu::milliseconds
    @explosion = Gosu::Image.load_tiles("explosion.png", 65, 65)
    @explosion_tile_index = 0
  end

  def draw
    unless @explosion_tile_index >= @explosion.size
      @explosion[@explosion_tile_index].draw(@x, @y, 1)
      current_time = Gosu::milliseconds
      if (current_time - @frame_start_time) > ANIMATION_SPEED
        @frame_start_time = current_time
        @explosion_tile_index += 1
      end
    end
  end
end
