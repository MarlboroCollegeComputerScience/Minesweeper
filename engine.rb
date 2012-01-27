#!/usr/bin/env ruby

=begin
  A Minesweeper Engine in Ruby
  
  Sam Auciello | Marlboro College
  Jan 2012     | opensource.org/licenses/MIT
=end

class Cell
  "A single cell in the game grid"
  attr_reader :hasMine, :mark, :game
  attr_accessor :adjacent, :pos
  def initialize hasMine, mark, game, adjacent
    @hasMine = hasMine or false
    @mark = mark
    @game = game
    @adjacent = adjacent
  end
  def to_s
    "Render the display value of the cell"
    case @mark
    when :f
      (@game.over and
       ((@hasMine and "F") or "X") or
       "F")
    when :c
      @adjacent.count{|cell| cell.hasMine}.to_s
    else
      (@game.over and
       ((@hasMine and "*") or "-") or
       "-")
    end
  end
  def check
    "Handle a click on this cell checking for adjacent mines"
    if @mark.nil?
      if @hasMine
        @game.finish false
      else
        @mark = :c
        if "0" == self.to_s
          @adjacent.each {|cell| cell.check}
        end
      end
    end
  end
  def flag
    "Handle a right-click on this cell flagging it as having a mine"
    if @mark.nil?
      @mark = :f
    end
  end
end

class Game
  attr_accessor :dimensions, :grid, :over
  def initialize height, width, mines
    @dimensions = {:height => height, :width => width}
    @grid = []
    
    # generate cells
    mineMap = ([true] * mines + [false] * ((height * width) - mines)).shuffle
    mineMap.each do |hasMine|
      @grid.push Cell.new hasMine, nil, self, []
    end
    
    # computer adjacency
    height.times do |row|
      width.times do |col|
        index = (row * width) + col
        adjacentCells = [-width - 1, -width, -width + 1,
                         -1,         0,      1,
                         width - 1,  width,  width + 1]
        adjacentCells.each_with_index do |cellIndex, position|
          puts "i:#{index} p:#{position} r:#{row} e:" +
            ((0 == position / 3 and 0 == row) or
             (2 == position / 3 and row >= height - 1) or
             (0 == position % 3 and 0 == col) or
             (2 == position % 3 and col >= width - 1) or
             (4 == position)).to_s if false
          
          next if ((0 == position / 3 and 0 == row) or
                   (2 == position / 3 and row >= height - 1) or
                   (0 == position % 3 and 0 == col) or
                   (2 == position % 3 and col >= width - 1) or
                   (4 == position))
          @grid[index].adjacent.push @grid[index + cellIndex]
        end
        @grid[index].pos = [row, col]
      end
    end
    
    @over = false
  end
  def to_s
    height = dimensions[:width]
    width = dimensions[:height]
    rows = height.times.map do |row|
      @grid[(row * width)..((row * width) + width - 1)].join " "
    end
    return "+" + ("--" * width) + "-+\n| " + rows.join(" |\n| ") + " |\n+" +
      ("--" * width) + "-+"
    return "foo"
  end
  def finish win
    @over = true
    puts "Game Over"
    puts (win and "you win!") or "you lose"
  end
end

# tests
if $0 == __FILE__
  g = Game.new 6, 6, 10
  puts g
  
  g.grid[35].flag
  puts g
  
  g.grid[0].check
  puts g
end
