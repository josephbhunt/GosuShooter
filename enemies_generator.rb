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

  def track_player(x, y)
    @enemies.each{|e| e.track(x, y)}
  end

  def kill_all
    enemies.each(&:die)
  end

  def draw
    if @enemies.any?
      @enemies.each(&:draw)
    else
      generate
    end
  end
end
