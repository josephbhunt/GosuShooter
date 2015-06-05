#!/usr/bin/env ruby

require 'gosu'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480

class MyWindow < Gosu::Window

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)

    self.caption = 'Space Shooter'
    @background_image = Gosu::Image.new("bg_space.png", tileable: true)
    center_x = WINDOW_WIDTH / 2
    center_y = WINDOW_HEIGHT / 2
    @player = Player.new(center_x, center_y + 150)
  end

  def update
    @player.move_left  if Gosu::button_down?(Gosu::KbLeft)
    @player.move_right  if Gosu::button_down?(Gosu::KbRight)
    @player_shot = @player.shoot  if Gosu::button_down?(Gosu::KbS)
    @player_shot = @player.shoot_stream  if Gosu::button_down?(Gosu::KbD)
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw
  end
end

class Player
  MOVE_INCREMENT = 3

  def initialize(x=0, y=0)
    @last_shot = Time.now.to_f
    @image = Gosu::Image.new("spaceship1.png")
    @x = x
    @y = y
    @vel_x = @vel_y = @angle = 0.0
    @shots = []
  end

  def move_left
    @x -= MOVE_INCREMENT
    @x %= WINDOW_WIDTH
  end

  def move_right
    @x += MOVE_INCREMENT
    @x %= WINDOW_WIDTH
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

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
    @shots.each(&:move_up)
  end
end

class Shot
  MOVE_INCREMENT = 5
  DELAY = 0.05

  def initialize(x, y)
    @x = x
    @y = y
    @angle = 0
    @image = Gosu::Image.new("shot.png")
  end

  def move_up
    @y -= MOVE_INCREMENT
    draw
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

class ShotStream < Shot
  FLOAT_INCREMENT = 1
  FLOAT_MAX = 4
  WIDTH = 4
  HEIGHT = 6

  def initialize(x, y)
    super
    @x -= WIDTH
    @y += HEIGHT
    @x_org = @x
    @float_right = true
  end

  def draw
    float_stream
    Gosu.draw_rect(@x, @y, WIDTH, HEIGHT, Gosu::Color::WHITE, 1)
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

window = MyWindow.new
window.show
