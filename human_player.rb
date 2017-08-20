require './player'
require 'io/console'

class HumanPlayer < Player
  # get input of the human player
  #
  # @return [Symbol] one of :nothing, :left, :right, :exit
  def input
    input = STDIN.getch

    case input
      when 'a' then return :left
      when 'd' then return :right
      when 'q' then return :exit
      else return :nothing
    end
  end
end
