# frozen_string_literal: true

# dependencies
require_relative 'atlas_mapper'
require_relative 'faux_renderer'

# scenes
require_relative 'game'

def boot(_args)
  $gtk.disable_console if $gtk.production?
end

def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end

def reset args
  $game = nil
end

$gtk.reset
