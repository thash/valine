module Valine
  class Window < ::Curses::Window
    def initialize(*args)
      super(*args)
      self.scrollok(true) # scroll whole lines displayed in window.

      ### Curses ###
      # The cbreak routine disables line buffering and erase/kill character-processing
      # (interrupt and flow control characters are unaffected),
      # making characters typed by the user immediately available to the program.
      Curses.cbreak
      # The echo and noecho routines control whether characters typed by the user
      # are echoed by getch as they are typed.
      Curses.noecho
    end

    def display(filename)
      @filename = filename
      begin
        @file = File.open(@filename, "a+")
        @lines = []
        @file.each_line do |line|
          @lines.push(line.chop)
        end
        @lines[0..(self.maxy - 1)].each_with_index do |line, idx|
          self.setpos(idx, 0)
          self.addstr(line)
        end
      rescue => e
        raise IOError, "Cannot open file: #{filename}\n #{e.message}"
      end
      @x = @y = 0
      @y_over = 0
      self.setpos(@x, @y)
      self.refresh
    end

    def input(char)
      self.insch(char)
      self.setpos(@y, @x += 1)
    end

    def delete
      self.delch
    end

    def cursor_down
      # move cursor
      if  @y >= (self.maxy - 1)
        scroll_down
      else
        @y += 1 unless @y >= (@lines.length - 1)
      end
      # if x position go over line length
      if @x >= (@lines[@y + @y_over].length)
        @x = @lines[@y + @y_over].length
      end
      self.setpos(@y, @x)
      self.refresh
    end

    def cursor_up
      # move cursor
      @y <= 0 ?  scroll_up : @y -= 1
      # if x position go over line length
      if @x >= (@lines[@y + @y_over].length)
        @x = @lines[@y + @y_over].length
      end
      self.setpos(@y, @x)
      self.refresh
    end

    def cursor_left
      @x -= 1 unless @x <= 0
      self.setpos(@y, @x)
      self.refresh
    end

    def cursor_right
      @x += 1 unless @x >= (@lines[@y + @y_over ].length)
      self.setpos(@y,@x)
      self.refresh
    end

    def scroll_up
      return if @y_over <= 0
      self.scrl(-1)
      @y_over -= 1
      str = @lines[@y_over]
      if str # fill one line if any
        self.setpos(0, 0)
        self.addstr(str)
      end
    end

    def scroll_down
      return unless @y_over + self.maxy < @lines.length
      self.scrl(1)
      str = @lines[@y_over + self.maxy]
      if str # fill one line if any
        self.setpos(self.maxy - 1, 0)
        self.addstr(str)
      end
      @y_over += 1
    end
  end
end
