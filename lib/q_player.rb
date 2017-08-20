require './lib/player'

class QPlayer < Player
  attr_reader :actions, :q_table,
    :learning_rate, :discount, :epsilon, :r,
    :old_score, :old_state, :action_taken_index

  # constructor
  def initialize(game)
    super(game)

    @actions = %i[ left right ]

    @learning_rate = 0.2
    @discount = 0.9
    @epsilon = 0.9

    @r = Random.new
  end

  # This method will be called on game start, the returned string will be printed
  #
  # @return [String]
  def start
    Signal.trap('INT') do # SIGINT = control-C
      game.stop!
    end

    <<-HINT.strip_heredoc.freeze
      Play the game with <QPlayer>. Lean back and watch the algorithm to learn playing the game.
      Quit game: [ctrl]+[c]
    HINT
  end

  # get the AI's input
  #
  # @return [Symbol] one of :left, :right, (:exit)
  def input
    sleep 0.05 # to follow the computed actions

    if q_table.nil?
      initialize_random_q_table
    else
      calculate_q_table_state
    end

    # capture current stuff
    @old_score = game.score
    @old_state = x

    # maybe do something random (chance: epsilon)
    @action_taken_index =
      if r.rand > epsilon
        r.rand(actions.length).round
      else
        q_table[x].each_with_index.max[1]
      end

    actions[action_taken_index]
  end

  private

  def calculate_q_table_state
    reward =
      if old_score < game.score
        1
      elsif old_score > game.score
        -1
      else
        0
      end

    q_table[old_state][action_taken_index] =
      q_table[old_state][action_taken_index] + learning_rate * (
      reward + discount * q_table[x].max - q_table[old_state][action_taken_index]
      )
  end

  # initialize the Q table
  def initialize_random_q_table
    @q_table = Array.new(game.map_size) { Array.new(actions.length) }

    game.map_size.times do |s|
      actions.length.times do |a|
        q_table[s][a] = r.rand
      end
    end
  end
end
