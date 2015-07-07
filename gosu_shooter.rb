#!/usr/bin/env ruby

require 'gosu'
require "./player"
require "./enemy"
require "./collidable"
require "./explosion"
require "./enemies_generator"
require "./item"
require 'ap'
require "./background"
require "./main_menu"
require "./game"

class GameWindow < Gosu::Window
  include GameConstants

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, fullscreen: false, update_interval: 10 )
    self.caption = 'Space Shooter'
    @game = Game.new
    @menu = MainMenu.new(@game, self)
  end

  def update
    close  if Gosu::button_down?(Gosu::KbEscape)
    @menu.update  unless @game.playing?
    @game.update  if @game.playing?
    if @game.end_game
      @game = Game.new
      @menu = MainMenu.new(@game, self)
    end
  end

  def draw
    @menu.draw  unless @game.playing?
    @game.draw  if @game.playing? && !@game.end_game
  end
end

window = GameWindow.new
window.show
