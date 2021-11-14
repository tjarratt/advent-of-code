#!/usr/bin/env ruby


def main
  directions = File.read('input.txt')
                   .split('')
                   .each_with_index
                   .partition { |_, i| i % 2 == 0 }
  
  grid = Hash.new(0)
  grid[[0, 0]] = 1
  
  count_visits(grid, directions.first)
  count_visits(grid, directions.last)
  
  puts grid.keys.size
end

def count_visits(grid, directions)
  x, y = 0, 0

  directions.map do |direction, _|
    case direction
      when '^'
          y = y+1
      when '<'
          x = x-1
      when '>'
          x = x+1
      when 'v'
          y = y-1
    end
  
    grid[[x, y]] += 1
  end
  
  grid.keys.size
end

main

