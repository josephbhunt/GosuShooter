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
  SCROLL_RATE = 0.5

  TILE_SIZE = 90

  def initialize
    @background_images = Gosu::Image.load_tiles("bg_blue.jpg", TILE_SIZE, TILE_SIZE, tileable: true)
    @bg_grid = Array.new(WINDOW_WIDTH / TILE_SIZE) {Array.new(WINDOW_HEIGHT / TILE_SIZE + 1)}
    @bg_grid.each_with_index do |row, x|
      row.each_with_index do |col, y|
        image_x = x * TILE_SIZE
        image_y = y * TILE_SIZE
        y_multiplyer = WINDOW_WIDTH / TILE_SIZE
        gt_image = @background_images[y * y_multiplyer + x]
        grid_tile = GridTile.new(x, y - TILE_SIZE, image_x, image_y, gt_image)
        @bg_grid[x][y] = grid_tile
      end
    end
  end

  def update
    @bg_grid.each{|bg_row| bg_row.each{|t| t.move_down(SCROLL_RATE)}}
  end

  def draw
    @bg_grid.each {|t_row| t_row.each {|t| t.draw  unless t.nil? }}
  end
end

class GridTile

  attr_accessor :grid_x, :grid_y, :image_x, :image_y, :image

  def initialize(grid_x, grid_y, image_x, image_y, image=nil)
    @grid_x, @grid_y, @image_x, @image_y, @image = grid_x, grid_y, image_x, image_y, image
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
