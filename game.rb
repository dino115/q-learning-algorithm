class Game
  attr_reader :player,
    :score, :runs, :moves,
    :map_size, :start_pos, :cheese_pos, :pit_pos, :max_score

  PLAYER = 'P'.freeze
  CHEESE = 'C'.freeze
  PIT = 'O'.freeze
  MAP = '='.freeze
  WALL = '#'.freeze

  # constructor
  #
  # @param [Player] player
  # @param [Hash] opts
  # @option opts [Integer] :map_size, default: 12
  # @option opts [Integer] :start_pos, default: 3
  # @option opts [Integer] :cheese_pos, default: 10
  # @option opts [Integer] :pit_pos, default: 0
  # @option opts [Integer] :max_score, default: 5
  def initialize(player, opts = {})
    @runs = 0
    @player = player.new(self)
    @map_size = opts.fetch(:map_size, 12)
    @start_pos = opts.fetch(:start_pos, 3)
    @cheese_pos = opts.fetch(:cheese_pos, 10)
    @pit_pos = opts.fetch(:pit_pos, 0)
    @max_score = opts.fetch(:max_score, 5)

    reset

    # Clear the console
    puts "\e[H\e[2J"
  end

  # reset game state
  def reset
    @runs += 1
    @score = 0
    @moves = 0

    player.x = start_pos
  end

  # run the game
  def run
    start_time = Time.now

    while score.between?(0 - max_score + 1, max_score - 1)
      draw
      handle_player_input
      check_player_pos
      @moves += 1
    end

    # draw one last time to update
    draw

    play_time = Time.now - start_time

    if score >= max_score
      puts " | Time #{play_time}s | You win in #{moves} moves!"
    else
      puts " | Time #{play_time}s | Game over after #{moves} moves..."
    end
  end

  private

  # move the player according to the given input
  def handle_player_input
    case player.input
      when :left
        player.x = player.x.positive? ? player.x - 1 : map_size - 1
      when :right
        player.x = player.x < map_size - 1 ? player.x + 1 : 0
      when :exit
        puts "\nQuit Game..."
        exit
    end
  end

  # check the player position to calculate the score and maybe reset the player to the beginning
  def check_player_pos
    if player.x == cheese_pos
      @score += 1
      player.x = start_pos
    elsif player.x == pit_pos
      @score -= 1
      player.x = start_pos
    end
  end

  # draw the game map
  def draw
    map_line =
      (0...map_size).map do |i|
        case i
          when player.x then PLAYER
          when cheese_pos then CHEESE
          when pit_pos then PIT
          else MAP
        end
      end

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    print "\r#{WALL}#{map_line.join}#{WALL} | Score #{score} | Run #{runs}"
  end
end
