#!/usr/bin/env ruby

=begin
  A human interface to play minesweeper using the engine in engine.rb.
  
  Use:
  ...
  
  Sam Auciello | Marlboro College
  Jan 2012     | opensource.org/licenses/MIT
=end

require "engine.rb"

# determine game dimensions
height = width = mines = nil
while height.nil? or width.nil? or mines.nil?
  print "Enter a height, width, and number of mines in the format HxW:M\n  > "
  m = /(\d+)x(\d+):(\d+)/.match gets
  if m.nil?
    puts "Error: invalid entry"
  elsif m[1].to_i * m[2].to_i < m[3].to_i
    puts "Error: too many mines"
  else
    height = m[1].to_i
    width = m[2].to_i
    mines = m[3].to_i
  end
end

game = Game.new height, width, mines
puts game
