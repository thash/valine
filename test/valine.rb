require 'minitest/autorun'
require 'minitest/mock'

require File.expand_path("../../lib/valine.rb", __FILE__)

class TestValine < Minitest::Unit::TestCase
  # TODO: テストを流すとconsoleにズレが発生する. 描画しないテストモードを作る.
  def setup
    @window = Valine::Window.new(Curses.lines, Curses.cols, 0, 0)
    @window.display('dummy.txt')
  end

  def test_hoge
    assert_equal @window.x, 0
  end
end
