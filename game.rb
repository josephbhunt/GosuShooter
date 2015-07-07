class Game
  include GameConstants

  attr_reader :game_over, :end_game, :playing

  def initialize
    @background = Background.new
    @song = Gosu::Song.new(SONG_SOUND_FILE)
    @hud_font = Gosu::Font.new(20)
    @game_over_font = Gosu::Font.new(30)
    player_start_x = WINDOW_WIDTH / 2
    player_start_y = WINDOW_HEIGHT - 80
    @player = Player.new(player_start_x, player_start_y)
    @enemy_gen = EnemyGenerator.new
    @explosions = []
    @items = []
    @time_since_game_over = nil
    @end_game = false
    @playing = false
  end

  def update
    @background.update
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
    @song.play  unless @song.playing?
    @background.draw
    Shot.draw_all
    @player.draw
    @enemy_gen.draw
    @explosions.each(&:draw)
    @items.each(&:draw)
    @hud_font.draw("Score: #{@player.score}", 10, 10, 2, 1.0, 1.0, 0xff_ffff00)
    @hud_font.draw("Stars: #{@player.stars}", 30, 30, 2, 1.0, 1.0, 0xff_ffff00)
    game_over  if @player.dead?
  end

  def game_over
    if @time_since_game_over.nil?
      @time_since_game_over = Time.now.to_f
      @game_over_font.draw_rel("GAME OVER!", (WINDOW_WIDTH / 2), (WINDOW_HEIGHT / 2), 2, 0.5, 0.5, 1, 1, 0xff_ffff00)
    elsif !@time_since_game_over.nil? && (Time.now.to_f - @time_since_game_over) < 3
      @game_over_font.draw_rel("GAME OVER!", (WINDOW_WIDTH / 2), (WINDOW_HEIGHT / 2), 2, 0.5, 0.5, 1, 1, 0xff_ffff00)
    elsif !@time_since_game_over.nil? && (Time.now.to_f - @time_since_game_over) > 3
      close_game
    end
  end

  def play
    @playing = true
  end

  def playing?
    @playing
  end

  def close_game
    @playing = false
    @song.stop
    @enemy_gen.kill_all
    Shot.kill_all
    @end_game = true
  end
end
