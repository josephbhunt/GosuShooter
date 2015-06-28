require "./background_image"

class Background
  include GameConstants
  SCROLL_RATE = 1

  def initialize
    @bg_image = BackgroundImage.new(Gosu::Image.new(BACKGROUND_IMAGE_FILE))
    @bg_image_2 = BackgroundImage.new(Gosu::Image.new(BACKGROUND_IMAGE_FILE), 0, -WINDOW_HEIGHT)
  end

  def update
    @bg_image.move_down(SCROLL_RATE)
    @bg_image_2.move_down(SCROLL_RATE)
    @bg_image.move_to_top  if @bg_image.y > @bg_image.image.height
    @bg_image_2.move_to_top  if @bg_image_2.y > @bg_image_2.image.height
  end

  def draw
    @bg_image.draw
    @bg_image_2.draw
  end
end
