require "./menu_option"

class Menu

  def initialize(items)
    @items = items
    @last_input_time = Time.now.to_f

    # TODO These fonts are styles for the menu. Maybe they should be somewhere else?
    @menu_font = Gosu::Font.new(40)
    @menu_selected_font = Gosu::Font.new(50)
  end

  # TODO Refactor me!!!
  def update
    if Gosu::button_down?(Gosu::KbDown) && (Time.now.to_f - @last_input_time) > 0.1
      selected_option = @items.find{|mo| mo.selected?}
      index_of_selected = @items.index(selected_option)
      if index_of_selected + 1 < @items.size
        @items[index_of_selected + 1].select
        selected_option.unselect
      end
      @last_input_time = Time.now.to_f
    end

    if Gosu::button_down?(Gosu::KbUp) && (Time.now.to_f - @last_input_time) > 0.1
      selected_option = @items.find{|mo| mo.selected?}
      index_of_selected = @items.index(selected_option)
      if index_of_selected > 0
        @items[index_of_selected - 1].select
        selected_option.unselect
      end
      @last_input_time = Time.now.to_f
    end

    if Gosu::button_down?(Gosu::KbReturn) && (Time.now.to_f - @last_input_time) > 0.1
      @items.find{|mo| mo.selected?}.action
    end
  end

  def draw

    # TODO The position and font style of the menu options should probably not be in this class.
    @items.each do |i|
      if i.selected?
        @menu_selected_font.draw_rel(i.text, i.x, i.y, 1, 0.5, 0.5, 1.0, 1.0, 0xff_ffff00)
      else
        @menu_font.draw_rel(i.text, i.x, i.y, 1, 0.5, 0.5, 1.0, 1.0, 0xff_ffff00)
      end
    end
  end
end
