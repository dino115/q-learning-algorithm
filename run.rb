#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'optparse'
require 'active_support/all'
require 'colorize'

require './lib/human_player'
require './lib/q_player'
require './lib/game'

# Run game with different options...
Options = Struct.new(:player, :runs, :map_size, :player_pos, :cheese_pos, :pit_pos, :max_score)
args = Options.new('HumanPlayer', 10, 12, 3, 10, 0, 5)
parser =
  OptionParser.new do |opts|
    opts.banner = 'Run the game in different modes. Usage: run.rb [options]'

    opts.on('-pPLAYER', '--player=PLAYER', String, 'Used player', %w[ HumanPlayer QPlayer ]) do |player|
      args.player = player
    end

    opts.on('-rRUNS', '--runs=RUNS', Integer, 'Total runs to to play') do |runs|
      args.runs = runs
    end

    opts.on('-mMAPSIZE', '--map-size=MAPSIZE', Integer, 'The size of the map') do |map_size|
      args.map_size = map_size
    end

    opts.on('--player-pos=PLAYERPOS', Integer, 'The players start position (must fit map size)') do |player_pos|
      args.player_pos = player_pos
    end

    opts.on('--cheese-pos=CHEESEPOS', Integer, 'The cheese position (must fit map size)') do |cheese_pos|
      args.cheese_pos = cheese_pos
    end

    opts.on('--pit-pos=PITPOS', Integer, 'The pit position (must fit map size)') do |pit_pos|
      args.pit_pos = pit_pos
    end

    opts.on('-sMAXSCORE', '--max-score=MAXSCORE', Integer, 'The maximum score needed to win a run') do |max_score|
      args.max_score = max_score
    end

    opts.on('-h', '--help', 'Prints this help') do
      puts opts
      exit
    end
  end

parser.parse!

# Initialize game
player_klass = args.player.constantize

begin
  game = Game.new(
    player_klass,
    args.to_h.slice(:map_size, :player_pos, :cheese_pos, :pit_pos, :max_score),
  )

  # Run
  game.start

  args.runs.times do
    game.run
    game.reset
  end

  game.stop
rescue ArgumentError => e
  puts "[ArgumentError] #{e.message}".red
rescue NotImplementedError => e
  puts "[NotImplemeted] #{e.message}".red
end
