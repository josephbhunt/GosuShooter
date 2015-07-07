require "./menu"

class MainMenu < Menu
  include GameConstants

  def initialize(game, window)
    @menu_options = [
      MenuOption.new("Start", (WINDOW_WIDTH / 2), (WINDOW_HEIGHT / 2)) do
        game.play
      end,
      MenuOption.new("Quit",(WINDOW_WIDTH / 2), (WINDOW_HEIGHT / 2 + 42)) do
        window.close
      end
    ]
    @menu_options.first.select
    super(@menu_options)
  end
end
