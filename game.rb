class Game
  attr_reader :player, :score, :run, :moves, :map_size, :start_pos, :cheese_pos, :pit_pos

  # constructor
  #
  # @param [Player] player
  # @param [Hash] opts
  # @option opts [Integer] :map_size, default: 12
  # @option opts [Integer] :start_pos, default: 3
  # @option opts [Integer] :cheese_pos, default: 10
  # @option opts [Integer] :pit_pos, default: 0
  def initialize(player, opts = {})
    @run = 0
    @player = player.new(self)
    @map_size = opts.fetch(:map_size, 12)
    @start_pos = opts.fetch(:start_pos, 3)
    @cheese_pos = opts.fetch(:cheese_pos, 10)
    @pit_pos = opts.fetch(:pit_pos, 0)

    reset

    # Clear the console
    puts "\e[H\e[2J"
  end

  # reset game state
  def reset
    @run += 1
    @score = 0
    @moves = 0

    @player.x = start_pos
  end

  # run the game
  def run
    while score < 5 && score > -5
      draw
      gameloop
      @moves += 1
    end

    # draw one last time to update
    draw

    if @score >= 5
      puts "  You win in #{@moves} moves!"
    else
      puts '  Game over'
    end

  end

  # the gameloop
  def gameloop
    move = player.input

    case move
      when :left
        player.x = player.x.positive? ? player.x - 1 : map_size - 1
      when :right
        player.x = player.x < map_size - 1 ? player.x + 1 : 0
      when :exit
        puts 'Quit Game...'
        exit
    end

    if player.x == cheese_pos
      @score += 1
      player.x = start_pos
    elsif player.x == pit_pos
      @score -= 1
      player.x = start_pos
    end
  end

  # draw the game
  def draw
    map_line = Array(map_size).map do |i|
      if player.x == i
        'P'
      elsif cheese_pos == i
        'C'
      elsif pit_pos == i
        'O'
      else
        '='
      end
    end

    map_line = "\r##{map_line.join}# | Score #{score} | Run #{run}"

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end
