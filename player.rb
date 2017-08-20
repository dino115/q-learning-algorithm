class Player
  attr_accessor :x, :game

  # constructor
  def initialize(game)
    @game = game
    @x = 0
  end

  # get the players input
  #
  # @return [Symbol] one of :nothing, :left, :right, :exit
  def input
    raise NotImplementedError, 'Please implement input method on your player class'
  end
end
