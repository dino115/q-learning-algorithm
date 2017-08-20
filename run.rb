require 'rubygems'
require 'bundler/setup'
require 'optparse'
require 'active_support/all'

require './lib/human_player'
require './lib/q_player'
require './lib/game'

# Run game with different options...
Options = Struct.new(:player, :runs, :map_size, :start_pos, :cheese_pos, :pit_pos, :max_score)
args = Options.new('HumanPlayer', 10, 12, 3, 10, 0, 5)
parser =
  OptionParser.new do |opts|
    opts.banner = 'Run the game in different modes. Usage: run.rb [options]'

    opts.on('-g', '--player=PLAYER', String, 'Used player class') do |g|
      args.player = g
    end

    opts.on('-r', '--runs=RUNS', Integer, 'How many runs to play') do |r|
      args.runs = r
    end

    opts.on('-m', '--map-size=MAPSIZE', Integer, 'Used map size') do |m|
      args.map_size = m
    end

    opts.on('-c', '--cheese-pos=CHEESEPOS', Integer, 'Cheese position') do |c|
      args.cheese_pos = c
    end

    opts.on('-p', '--pit-pos=PITPOS', Integer, 'Pit position') do |p|
      args.pit_pos = p
    end

    opts.on('-s', '--max-score=MAXSCORE', Integer, 'The maximum score') do |s|
      args.max_score = s
    end

    opts.on('-h', '--help', 'Prints this help') do
      puts opts
      exit
    end
  end

parser.parse!

# Initialize game
player_klass = args.player.constantize
game = Game.new(
  player_klass,
  args.to_h.slice(:map_size, :start_pos, :cheese_pos, :pit_pos, :max_score),
)

# Run
args.runs.times do
  game.run
  game.reset
end

puts "\nGame completed, you played #{args.runs} runs"
