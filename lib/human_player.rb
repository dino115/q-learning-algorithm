require 'io/console'

require './lib/player'

class HumanPlayer < Player
  # This method will be called on game start, the returned string will be printed
  #
  # @return [String]
  def start
    <<-HINT.strip_heredoc.freeze
      Play the game with <HumanPlayer>
      Move left: "a" | Move right: "d" | Quit Game: "q"
    HINT
  end

  # get input of the human player
  #
  # @return [Symbol] one of :left, :right, :exit
  def input
    loop do
      case STDIN.getch
        when 'a' then return :left
        when 'd' then return :right
        when 'q' then return :exit
      end
    end
  end
end
