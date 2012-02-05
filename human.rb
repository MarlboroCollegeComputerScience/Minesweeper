#!/usr/bin/env ruby

=begin
  A human interface to play minesweeper using the engine in engine.rb.
  
  The engine makes obvious moves for the player.
  Specifically, if a marked Cell has n mines adjacent to it, and there are
  only n unchecked Cells adjacent to it, all of them are automatically
  flagged.  Also if a marked Cell has n mines adjacent to it, and there are n
  flagged Cells adjacent to it, the remaining adjacent cells are automatically
  checked.  This effectively eliminates the vast majority of tedious thought
  from the game and reduces the game to the more interesting decisions.
  
  An example session can be found in human_example.txt
  
  Sam Auciello | Marlboro College
  Jan 2012     | opensource.org/licenses/MIT
=end

require "engine.rb"

# determine game dimensions
height = width = mines = nil
while height.nil? or width.nil? or mines.nil?
  print "Enter a height, width, and number of mines in the format HxW:M\n  > "
  m = /^(\d+)x(\d+):(\d+)$/.match gets
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

# start game
game = Game.new height, width, mines
until game.over
  puts game
  print "To flag square, enter f:R,C\n where R and C correspond to the row " +
    "and column of the desired cell.\nTo check a square, enter c:R,C\nTo " +
    "concede enter exit\n  > "
  entry = gets
  if "exit" == entry.strip
    game.finish false
  else
    m = /^(c|f):(\d+),(\d+)$/.match entry.strip
    if m.nil?
      puts "Error: invalid entry"
    elsif m[2].to_i >= height or m[3].to_i >= width
      puts "Error: coordinates outside of grid"
    else
      case m[1]
      when "c"
        game[m[2].to_i, m[3].to_i].check
      when "f"
        game[m[2].to_i, m[3].to_i].flag
      end
      game.doObviousMoves
    end
  end
end
