#!/usr/bin/env ruby

def main
    grid = File.read("input.txt")
        .split("\n")
        .map {|l| l.split('').map(&:to_i) }

    low_points = grid.each_with_index
                     .map {|row, y| row.each_with_index.filter {|value, x| low_point?(grid, y, x) }.map {|v, x| [y, x] } }
                     .reject(&:empty?)
                     .flatten(1)

    basins = []
    low_points.each do |point|
        basin = [point]

        candidates = neighbors(grid, *point).filter {|y, x| grid[y][x] < 9 }
        while candidates.size > 0
            basin.append(*candidates)

            next_gen = candidates.map {|y, x| neighbors(grid, y, x) }
                                 .flatten(1)
                                 .reject {|candidate| basin.include?(candidate) }
                                 .filter {|y, x| grid[y][x] < 9 }
            candidates = next_gen
        end

        basins << basin.uniq
    end

    puts basins.sort_by(&:size)
               .reverse
               .map(&:size)
               .take(3)
               .inject(:*)
end

def low_point?(grid, y, x)
    v = grid[y][x]
    neighbors = []
    neighbors << [y, x - 1] unless x == 0
    neighbors << [y, x + 1] unless x == grid.first.size - 1
    neighbors << [y - 1, x] unless y == 0
    neighbors << [y + 1, x] unless y == grid.size - 1

    neighbors.all? {|ny, nx| v < grid[ny][nx] }
end

def neighbors(grid, y, x)
    neighbors = []
    neighbors << [y, x - 1] unless x == 0
    neighbors << [y, x + 1] unless x == grid.first.size - 1
    neighbors << [y - 1, x] unless y == 0
    neighbors << [y + 1, x] unless y == grid.size - 1
    neighbors
end

main
