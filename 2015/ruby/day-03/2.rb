#!/usr/bin/env ruby

x, y = 0, 0
rx, ry = 0, 0
grid = Hash.new(0)
grid[[x, y]] = 1

directions = File.read('input.txt')
                 .split('')
                 .each_with_index
                 .partition { |_, i| i % 2 == 0 }

directions.first.map do |direction, _|
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

directions.last.map do |direction, _|
  case direction
    when '^'
        ry = ry+1
    when '<'
        rx = rx-1
    when '>'
        rx = rx+1
    when 'v'
        ry = ry-1
  end

  grid[[rx, ry]] += 1
end

puts grid.keys.size

