require 'rubygems'
require 'bundler/setup'
require 'optparse'
require 'active_support/all'

require './human_player'
require './q_player'
require './game'

Options = Struct.new(:player, :map_size, :start_pos, :cheese_pos, :pit_pos)

class Parser
  # option parse
  def self.parse(options)
    args = Options.new('HumanPlayer', 12, 3, 10, 0)

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: run.rb [options]'

      opts.on('-gPLAYER', '--player=PLAYER', 'Used player class') do |g|
        args.player = g
      end

      opts.on('-mMAP_SIZE', '--map-size=MAP_SIZE', 'Used map size') do |m|
        args.map_size = m
      end

      opts.on('-cCHEESE_POS', '--cheese-pos=CHEESE_POS', 'Cheese position') do |c|
        args.cheese_pos = c
      end

      opts.on('-pPIT_POS', '--pit-pos=PIT_POS', 'Pit position') do |p|
        args.pit_pos = p
      end

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)

    args
  end
end

options = Parser.parse %w[--help]
player_klass = options.delete(:player).constantize
player = player_klass.new

game = Game.new(player, options)

if player.is_a?(HumanPlayer)
  game.run
else
  10.times do
    game.run
    game.reset
  end

  puts 'Done'
end
