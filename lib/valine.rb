require 'curses'

Dir.glob(File.expand_path("../valine/*.rb", __FILE__)).each{|f| require f }

module Valine
  class Command
    attr_accessor :filename
    def initialize(filenames)
      raise if filenames.size != 1
      @filename = filenames.first
    end

    def start
      Curses.init_screen
      Curses.cbreak
      Curses.noecho

      window = Window.new
      window.display(@filename)

      handler = KeyHandler.new
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
