class Player
  attr_accessor :x, :game

  # constructor
  def initialize(game)
    @game = game
    @x = 0
  end

  # This method will be called on game start, the returned string will be printed
  #
  # @return [String]
  def start
    "Play with <#{self.class.name}>"
  end

  # get the players input
  #
  # @return [Symbol] one of :left, :right, :exit
  def input
    raise NotImplementedError, 'Please implement input method on your player class'
  end

  # This method will be called on game stop, the returned string will be printed
  #
  # @return [String]
  def stop
    "Stop <#{self.class.name}>"
  end
end
