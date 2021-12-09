#!/usr/bin/env ruby

def main
    grid = File.read("input.txt")
        .split("\n")
        .map {|l| l.split('').map(&:to_i) }

    puts grid.each_with_index
             .map {|row, y| row.each_with_index.filter {|value, x| low_point?(grid, x, y) }.map(&:first) }
             .reject(&:empty?)
             .flatten
             .map(&:next)
             .inject(:+)
end

def low_point?(grid, x, y)
    v = grid[y][x]
    neighbors = []
    neighbors << [y, x - 1] unless x == 0
    neighbors << [y, x + 1] unless x == grid.first.size - 1
    neighbors << [y - 1, x] unless y == 0
    neighbors << [y + 1, x] unless y == grid.size - 1

    neighbors.all? {|ny, nx| v < grid[ny][nx] }
end

main
