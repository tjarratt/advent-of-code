#!/usr/bin/env ruby

x, y = 0, 0
grid = Hash.new(0)
grid[[x, y]] = 1

File.read('input.txt')
    .split('')
    .map do |direction|
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

puts grid.keys.size

