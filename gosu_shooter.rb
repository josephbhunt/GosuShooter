#!/usr/bin/env ruby

require 'gosu'
require "./player"
require "./enemy"
require "./collidable"

class MyWindow < Gosu::Window
  include GameConstants

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = 'Space Shooter'

    @font = Gosu::Font.new(20)
    @background_image = Gosu::Image.new("bg_space.png", tileable: true)
    player_start_x = WINDOW_WIDTH / 2
    player_start_y = WINDOW_HEIGHT - 80
    @player = Player.new(player_start_x, player_start_y)
    @enemy_gen = EnemyGenerator.new
  end

  def update
    @player.move_left  if Gosu::button_down?(Gosu::KbLeft)
    @player.move_right  if Gosu::button_down?(Gosu::KbRight)
    @player.move_up  if Gosu::button_down?(Gosu::KbUp)
    @player.move_down  if Gosu::button_down?(Gosu::KbDown)
    @player_shot = @player.shoot  if Gosu::button_down?(Gosu::KbS)
    @player_shot = @player.shoot_stream  if Gosu::button_down?(Gosu::KbA)
    @player.die  if @enemy_gen.enemies.any?{|e| e.collided_with?(@player)}
    close  if Gosu::button_down?(Gosu::KbEscape)

    @enemy_gen.enemies.each(&:move_down)
    @enemy_gen.enemies.each do |e|
      @player.shots.each do |s|
        if e.live? && e.collided_with?(s)
          e.die 
          @player.stop_shot(s)
          @player.add_to_score(e.points)
        end
        @player.stop_shot(s)  if s.off_screen?
      end
      e.die  if e.off_screen?
    end

    @enemy_gen.clean_up
  end

  def draw
    @background_image.draw(0, 0, 0)
    @player.draw  unless @player.dead?
    @enemy_gen.draw
    @font.draw("Score: #{@player.score}", 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
    game_over  if @player.dead?
  end

  def game_over
    @font.draw("GAME OVER!", (WINDOW_WIDTH / 2.5), (WINDOW_HEIGHT / 2), 2, 2.0, 2.0, 0xff_ffff00)
  end
end

class EnemyGenerator
  include GameConstants

  attr_accessor :enemies

  def initialize
    generate
  end

  def generate
    enemy_start_y = -80
    @enemies = 3.times.map{Enemy.new(rand(1000) % WINDOW_WIDTH, enemy_start_y)}
  end

  def clean_up
    @enemies.delete_if{|e| e.dead?}
  end

  def draw
    if @enemies.any?
      @enemies.each(&:draw)
    else
      generate
    end
  end
end

window = MyWindow.new
window.show
