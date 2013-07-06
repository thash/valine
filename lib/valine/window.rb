module Valine
  class Window < ::Curses::Window
    def initialize(*args)
      super(*args)
      self.scrollok(true) # scroll whole lines displayed in window.

      ### Curses ###
      # disables line buffering and erase/killcharacter-processing.
      # (interrupt and flow control characters are unaffected)
      # characters typed by the user immediately available to the program.
      Curses.cbreak
      # control whether characters typed by the user
      # are echoed by getch as they are typed.
      Curses.noecho
    end

    def display(filename)
      edit(filename)
      @y = @x = 0
      @y_over = 0
      move(@y, @x)
    end

    def move(y, x)
      setpos(y, x)
      refresh
    end

    def input(char)
      insch(char)
      setpos(@y, @x += 1)
    end

    def cursor_down
      # move cursor
      if  @y >= (maxy - 1)
        scroll_down
      else
        @y += 1 unless @y >= (@lines.length - 1)
      end
      # if x position go over line length
      if @x >= (@lines[@y + @y_over].length)
        @x = @lines[@y + @y_over].length
      end
      move(@y, @x)
    end

    def cursor_up
      # move cursor
      @y <= 0 ?  scroll_up : @y -= 1
      # if x position go over line length
      if @x >= (@lines[@y + @y_over].length)
        @x = @lines[@y + @y_over].length
      end
      move(@y, @x)
    end

    def cursor_left
      @x -= 1 unless @x <= 0
      move(@y, @x)
    end

    def cursor_right
      @x += 1 unless @x >= (@lines[@y + @y_over].length)
      move(@y, @x)
    end

    def scroll_up
      return if @y_over <= 0
      scrl(-1)
      @y_over -= 1
      str = @lines[@y_over]
      if str # fill one line if any
        setpos(0, 0)
        addstr(str)
      end
    end

    def scroll_down
      return unless @y_over + maxy < @lines.length
      scrl(1)
      str = @lines[@y_over + maxy]
      if str # fill one line if any
        setpos(maxy - 1, 0)
        addstr(str)
      end
      @y_over += 1
    end

    private

    def edit(filename)
      @file = File.open(filename, 'a+')
      @file.each_line do |line|
        (@lines ||= []).push(line.chop)
      end
      @lines[0..(self.maxy - 1)].each_with_index do |line, idx|
        self.setpos(idx, 0)
        self.addstr(line)
      end
    rescue => e
      raise IOError, "Cannot open file: #{filename}\n #{e.message}"
    end

  end
end
