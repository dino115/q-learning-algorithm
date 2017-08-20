class Game
  attr_reader :player,
    :score, :runs, :moves,
    :map_size, :player_pos, :cheese_pos, :pit_pos, :max_score,
    :start_time, :total_moves

  PLAYER = 'P'.yellow.freeze
  CHEESE = 'C'.green.freeze
  PIT = 'O'.red.freeze
  MAP = '='.light_white.freeze
  WALL = '#'.light_black.freeze

  # constructor
  #
  # @param [Player] player_klass
  # @param [Hash] opts
  # @option opts [Integer] :map_size, default: 12
  # @option opts [Integer] :player_pos, default: 3
  # @option opts [Integer] :cheese_pos, default: 10
  # @option opts [Integer] :pit_pos, default: 0
  # @option opts [Integer] :max_score, default: 5
  def initialize(player_klass, opts = {})
    @player = player_klass.new(self)
    @map_size = opts.fetch(:map_size, 12)
    @player_pos = opts.fetch(:player_pos, 3)
    @cheese_pos = opts.fetch(:cheese_pos, 10)
    @pit_pos = opts.fetch(:pit_pos, 0)
    @max_score = opts.fetch(:max_score, 5)

    raise ArgumentError, "player_pos doesn't fit map_size" unless player_pos.between?(0, map_size - 1)
    raise ArgumentError, "cheese_pos doesn't fit map_size" unless cheese_pos.between?(0, map_size - 1)
    raise ArgumentError, "pit_pos doesn't fit map_size" unless pit_pos.between?(0, map_size - 1)
    raise ArgumentError, "cheese and pit can't be on the same position" if cheese_pos == pit_pos
    raise ArgumentError, "player_pos can't be on the cheese or pit position" if [cheese_pos, pit_pos].include?(player_pos)
  end

  # start game
  def start
    @runs = 0
    @start_time = Time.now
    @total_moves = @moves = 0

    reset

    print "\e[H\e[2J" # Clear the console
    puts 'Catch The Cheese'.cyan.bold
    puts "\n"
    puts <<-TEXT.strip_heredoc
      Game options:
        map_size: #{map_size.to_s.magenta} | max_score: #{max_score.to_s.magenta}
        player_pos: #{player_pos.to_s.magenta} | cheese_pos: #{cheese_pos.to_s.magenta} | pit_pos: #{pit_pos.to_s.magenta}
      Optimal Statistics:
        Moves needed to score: #{moves_to_score.to_s.magenta} | Moves needed to win run: #{moves_to_win.to_s.magenta}
    TEXT
    puts "\n" + player.start.yellow + "\n"
  end

  # reset game state
  def reset
    @runs += 1
    @score = 0
    @moves = 0

    player.x = player_pos
  end

  # run the game
  def run
    run_start_time = Time.now

    while score.between?(0 - max_score + 1, max_score - 1)
      draw
      handle_player_input
      check_player_pos
      @total_moves += 1
      @moves += 1
    end

    # draw one last time to update
    draw

    play_time = Time.now - run_start_time

    if score >= max_score
      win_text = "You win in #{moves.to_s.magenta} moves!".green
      win_text = win_text.blink if moves == moves_to_win
      puts " | Time #{play_time.to_s.magenta}s | " + win_text
    else
      puts " | Time #{play_time.to_s.magenta}s | " + "Game over after #{moves.to_s.magenta} moves...".red
    end
  end

  # stop game and print summary
  def stop
    play_time = Time.now - start_time

    puts "\n"
    puts "\n" + player.stop.yellow + "\n"
    puts "Total play time #{play_time}s | Total runs #{runs - 1} | Total moves #{total_moves} | Quit game...".green
  end

  # stop game and exit immediately
  #
  # @exit
  def stop!
    stop
    exit
  end

  private

  # calculate the minimum moves needed to score
  def moves_to_score
    @_moves_to_score ||=
      begin
        positions = [cheese_pos, player_pos]
        if pit_pos.between?(positions.min, positions.max)
          if pit_pos > player_pos
            player_pos + map_size - cheese_pos
          else
            map_size - player_pos + cheese_pos
          end
        else
          (cheese_pos - player_pos).abs
        end
      end
  end

  # calculate the minimum moves needed to win a run
  def moves_to_win
    @_moves_to_win ||= moves_to_score * max_score
  end

  # move the player according to the given input
  def handle_player_input
    case player.input
      when :left
        player.x = player.x.positive? ? player.x - 1 : map_size - 1
      when :right
        player.x = player.x < map_size - 1 ? player.x + 1 : 0
      when :exit
        stop!
    end
  end

  # check the player position to calculate the score and maybe reset the player to the beginning
  def check_player_pos
    if player.x == cheese_pos
      @score += 1
      player.x = player_pos
    elsif player.x == pit_pos
      @score -= 1
      player.x = player_pos
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
    print "\r" + "#{WALL}#{map_line.join}#{WALL}" + " | Score #{score.to_s.magenta} | Run #{runs.to_s.magenta}"
  end
end
