module Valine
  class Config
    attr_accessor :options
    def initialize
      @options = {}
      options['runtimepath'] = default_rtps
      config_files.each do |file|
        load_config file
      end
    end

    def config_files
      [File.open(ENV['HOME'] + '/.vimrc')]
    end

    def load_config(file)
      file.each_line do |line|
        set_option(line) if line =~ /^set/
        # TODO: another vimrc configuration here.
      end
    end

    def set_option(line)
      statement = line.gsub('set ', '').split.first.split('=')
      if statement.length == 1
        puts statement
        # TODO: set "no" to false
        options[statement[0]] = true
      else
        options[statement[0]] = statement[1]
      end
    end

    def default_rtps
      [
        # ENV['VIM']  + '/vimfiles',
        # ENV['VIM']  + '/vimfiles/after',
        ENV['HOME'] + '/.vim',
        ENV['HOME'] + '/.vim/after',
        # ENV['VIMRUNTIME']
      ]
    end
  end
end
