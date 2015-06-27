#!/usr/bin/env ruby

require 'gosu'
require "./player"
require "./enemy"
require "./collidable"
require "./explosion"
require "./enemies_generator"
require "./item"
require 'ap'

class MyWindow < Gosu::Window
  include GameConstants

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = 'Space Shooter'

    @font = Gosu::Font.new(20)
    @background = Background.new

    player_start_x = WINDOW_WIDTH / 2
    player_start_y = WINDOW_HEIGHT - 80
    @player = Player.new(player_start_x, player_start_y)
    @enemy_gen = EnemyGenerator.new
    @explosions = []
    @items = []
  end

  def update
    @background.update
    close  if Gosu::button_down?(Gosu::KbEscape)
    @player.update  if @player.live?
    
    if @enemy_gen.enemies.any?{|e| e.collided_with?(@player)}
      @player.die
      @explosions << Explosion.new(@player.x, @player.y)
    end

    @enemy_gen.enemies.each(&:move_down)
    @enemy_gen.enemies.each do |e|
      Shot.all.each do |s|
        if e.live? && e.collided_with?(s)
          e.die 
          @explosions << Explosion.new(e.x, e.y)
          @items << Item.new(e.x, e.y)  if rand(10) == 1
          s.die
          @player.add_to_score(e.points)
        end
      end
      e.die  if e.off_screen?
    end
    Shot.update_all
    @enemy_gen.track_player(@player.x, @player.y)
    @enemy_gen.clean_up

    @items.each do |i|
      if i.collided_with?(@player)
        @player.collect_star
        i.die
      end
    end
  end

  def draw
    @background.draw
    Shot.draw_all
    @player.draw
    @enemy_gen.draw
    @explosions.each(&:draw)
    @items.each(&:draw)
    @font.draw("Score: #{@player.score}", 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
    @font.draw("Stars: #{@player.stars}", 30, 30, 2, 1.0, 1.0, 0xff_ffff00)
    game_over  if @player.dead?
  end

  def game_over
    @font.draw("GAME OVER!", (WINDOW_WIDTH / 2.5), (WINDOW_HEIGHT / 2), 2, 2.0, 2.0, 0xff_ffff00)
  end
end

class Background
  include GameConstants
  SCROLL_RATE = 1

  def initialize
    @bg_image = BackgroundImage.new(Gosu::Image.new("bg_blue.jpg"))
    @bg_image_2 = BackgroundImage.new(Gosu::Image.new("bg_blue.jpg"), 0, -WINDOW_HEIGHT)
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

class Grid
  include GameConstants

  attr_accessor :tiles, :map

  def initialize(ordered_images)
    @tiles = ordered_images.map{|oi| GridTile.new(oi)}
    @grid_height = WINDOW_HEIGHT / TILE_SIZE + 2
    @map = Array.new(WINDOW_WIDTH / TILE_SIZE) {Array.new(WINDOW_HEIGHT / TILE_SIZE + 2)}
    
    @map.each_with_index do |row, x|
      row.each_with_index do |col, y|
        if y == 0
        elsif y > 0 && y < @grid_height - 2
          image_x = x * TILE_SIZE
          image_y = y * TILE_SIZE
          y_multiplyer = WINDOW_WIDTH / TILE_SIZE
          grid_tile = @tiles[(y * y_multiplyer + x)]
          grid_tile.set_grid_location(x, y - TILE_SIZE) 
          grid_tile.set_image_location(image_x, image_y)
          @map[x][y] = grid_tile
        else

        end
      end
    end
  end

  def draw
    map.each {|t_row| t_row.each {|t| t.draw  unless t.nil? }}
  end
end

class GridTile

  attr_accessor :grid_x, :grid_y, :image_x, :image_y, :image

  def initialize(image, grid_x=nil, grid_y=nil, image_x=nil, image_y=nil)
    @grid_x, @grid_y, @image_x, @image_y, @image = grid_x, grid_y, image_x, image_y, image
  end

  def set_grid_location(x, y)
    @grid_x, @grid_y = x, y
  end

  def set_image_location(x, y)
    @image_x, @image_y = x, y
  end

  def move_down(rate=1)
    @image_y += rate
  end

  def draw
    image.draw(@image_x, @image_y, 1)  unless image.nil?
  end
end

window = MyWindow.new
window.show
