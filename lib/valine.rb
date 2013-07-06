require 'curses'

Dir.glob(File.expand_path("../valine/*.rb", __FILE__)).each{|f| require f }

module Valine
  class Command
    attr_accessor :filename
    def initialize(filenames)
      #TODO: allow multiple files
      raise if filenames.size != 1
      @filename = filenames.first
    end

    def start
      window = Window.new(Curses.lines, Curses.cols, 0, 0)
      window.display(@filename)

      handler = KeyHandler.new(:normal)
      begin
        while true
          key = window.getch
          handler = handler.handle(window, key)
        end
      end
      Cursor.close_screen
    end
  end
end
