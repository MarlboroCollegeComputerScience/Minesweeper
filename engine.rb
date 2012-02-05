#!/usr/bin/env ruby

=begin
  A Minesweeper Engine in Ruby
  
  The engine consists of a Game class and a Cell class.
  
  A Cell represents a single square in the game grid.
  Each Cell knows whether it has a mine, how it is marked, and which cells it is
  adjacent to.
  
  A Game contains grid of cells.
  
  Sam Auciello | Marlboro College
  Jan 2012     | opensource.org/licenses/MIT
=end

class Cell
  "A single square in the game grid"
  attr_reader :hasMine, :mark, :game
  attr_accessor :adjacent
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
    return if @game.over
    if @mark.nil?
      if @hasMine
        @game.finish false
      else
        @mark = :c
        if "0" == self.to_s
          @adjacent.each{|cell| cell.check}
        end
      end
    end
  end
  def flag
    "Handle a right-click on this cell flagging it as having a mine"
    return if @game.over
    case @mark
    when nil
      @mark = :f
    when :f
      @mark = nil
    end
  end
  def checkAdjacent
    "Check all Cells adjacent to this one if Cell's mines have been accounted
      for by flags"
    return unless :c == @mark
    adjMines = @adjacent.count{|cell| cell.hasMine}
    adjFlags = @adjacent.count{|cell| :f == cell.mark}
    @adjacent.each{|cell| cell.check} if adjFlags >= adjMines
  end
end

class Game
  "A game of minesweeper"
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
          next if ((0 == position / 3 and 0 == row) or
                   (2 == position / 3 and row >= height - 1) or
                   (0 == position % 3 and 0 == col) or
                   (2 == position % 3 and col >= width - 1) or
                   (4 == position))
          @grid[index].adjacent.push @grid[index + cellIndex]
        end
      end
    end
    
    @over = false
  end
  def [] row, col
    "Access the grid"
  	@grid[(row * dimensions[:width]) + col]
  end
  def to_s
    "Display the grid"
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
    "End the game: takes a boolian of whether the game was won or lost."
    @over = true
    puts "Game Over"
    puts (win and "you win!") or "you lose"
  end
end

# tests
if $0 == __FILE__
  g = Game.new 6, 6, 10
  
  g[5, 5].flag
  puts g
  
  g[0, 0].check
  puts g
  
  g[0, 5].check
  puts g
  
  g[5, 0].check
  puts g
end
