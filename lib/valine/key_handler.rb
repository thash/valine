module Valine
  class KeyHandler
    attr_accessor :mode
    def initialize(mode=:normal)
      @mode = mode
    end

    def handle(window, key)
      if mode == :normal
        case key
        when ?h then window.cursor_left
        when ?j then window.cursor_down
        when ?k then window.cursor_up
        when ?l then window.cursor_right
        when ?x then window.delch
        when ?i,?a then return KeyHandler.new(:insert)
        when ?q then raise 'しゅーりょー'
        end
      elsif mode == :insert
        case key
        when 27 then return KeyHandler.new(:normal) # ESC
        else window.input(key)
        end
      end
      return self
    end
  end
end
