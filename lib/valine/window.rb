module Valine
  class Window
    def initialize
      @window = Curses.stdscr
      @window.scrollok(true)
    end

    def display(filename)
      @filename = filename
      begin
        @file = File.open(@filename, "a+")
        @lines = []
        @file.each_line do |line|
          @lines.push(line.chop)
        end
        @lines[0..(@window.maxy - 1)].each_with_index do |line, idx|
          @window.setpos(idx, 0)
          @window.addstr(line)
        end
      rescue
        raise IOError, "Cannot open file: #{filename}"
      end
      @x = @y = 0
      @y_over = 0
      @window.setpos(@x, @y)
      @window.refresh
    end

    def getch
      return @window.getch
    end

    def input(char)
      @window.insch(char)
      @window.setpos(@y, @x += 1)
    end

    def delete
      @window.delch
    end

    def cursor_down
      # move cursor
      if  @y >= (@window.maxy - 1)
        scroll_down
      else
        @y += 1 unless @y >= (@lines.length - 1)
      end
      # if x position go over line length
      if @x >= (@lines[@y + @y_over].length)
        @x = @lines[@y + @y_over].length
      end
      @window.setpos(@y, @x)
      @window.refresh
    end

    def cursor_up
      # move cursor
      @y <= 0 ?  scroll_up : @y -= 1
      # if x position go over line length
      if @x >= (@lines[@y + @y_over].length)
        @x = @lines[@y + @y_over].length
      end
      @window.setpos(@y, @x)
      @window.refresh
    end

    def cursor_left
      @x -= 1 unless @x <= 0
      @window.setpos(@y, @x)
      @window.refresh
    end

    def cursor_right
      @x += 1 unless @x >= (@lines[@y + @y_over ].length)
      @window.setpos(@y,@x)
      @window.refresh
    end

    def scroll_up
      return if @y_over <= 0
      @window.scrl(-1)
      @y_over -= 1
      str = @lines[@y_over]
      if str # fill one line if any
        @window.setpos(0, 0)
        @window.addstr(str)
      end
    end

    def scroll_down
      return unless @y_over + @window.maxy < @lines.length
      @window.scrl(1)
      str = @lines[@y_over + @window.maxy]
      if str # fill one line if any
        @window.setpos(@window.maxy - 1, 0)
        @window.addstr(str)
      end
      @y_over += 1
    end
  end
end
