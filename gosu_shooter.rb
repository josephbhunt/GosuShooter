#!/usr/bin/env ruby

require 'gosu'
require "./player"
require "./enemy"
require "./collidable"
require "./explosion"
require "./enemies_generator"
require "./item"

class MyWindow < Gosu::Window
  include GameConstants

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = 'Space Shooter'

    @font = Gosu::Font.new(20)
    @background_image = Gosu::Image.new("bg_blue.jpg")
    player_start_x = WINDOW_WIDTH / 2
    player_start_y = WINDOW_HEIGHT - 80
    @player = Player.new(player_start_x, player_start_y)
    @enemy_gen = EnemyGenerator.new
    @explosions = []
    @items = []
  end

  def update
    close  if Gosu::button_down?(Gosu::KbEscape)
    @player.move_left  if Gosu::button_down?(Gosu::KbLeft)
    @player.move_right  if Gosu::button_down?(Gosu::KbRight)
    @player.move_up  if Gosu::button_down?(Gosu::KbUp)
    @player.move_down  if Gosu::button_down?(Gosu::KbDown)
    @player_shot = @player.shoot  if Gosu::button_down?(Gosu::KbS)
    @player_shot = @player.shoot_stream  if Gosu::button_down?(Gosu::KbA)
    
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
    @background_image.draw(0, 0, 0)
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

window = MyWindow.new
window.show
