class MenuOption

  attr_accessor :text, :x, :y

  def initialize(text, x, y, &block)
    @text, @x, @y = text, x, y
    @selected = false
    @action = block
  end

  def selected?
    @selected
  end

  def select
    @selected = true
  end

  def unselect
    @selected = false
  end

  def action
    @action.call  unless @action.nil?
  end
end
