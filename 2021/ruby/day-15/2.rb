#!/usr/bin/env ruby

require 'set'

# note : 2838 is too high (also someone eles's answer)

def main
    grid = File.read('input.txt')
               .split("\n")
               .map { _1.split('').map(&:to_i) }
    grid = embiggen(grid)

    start = [0, 0]
    goal = [grid.first.size - 1, grid.size - 1]

    path = a_star(grid, start, goal)

    puts path.inspect
    puts path.drop(1).map {value_at(_1, grid) }.inject(:+)
end
  
def a_star(grid, start, goal) 
    gScore = Hash.new(Float::INFINITY)
    gScore[start] = 0
    
    fScore = Hash.new(Float::INFINITY)
    fScore[start] = 0
    
    cameFrom = Hash.new
    openSet = [start]
   
    i = 0 
    while openSet.any?
        current = cheapest(openSet, fScore)
        if current == goal
            return reconstruct(cameFrom, current)
        end
        
        puts "iteration #{i} -- considering #{current} with #{openSet.size} neighbors" if (i += 1) % 1000 == 0

        openSet.delete(current)

        neighbors_of(current, grid).each do |neighbor|
            tentative_gScore = gScore[current] + value_at(current, grid) + value_at(neighbor, grid)
            next unless tentative_gScore < gScore[neighbor]

            cameFrom[neighbor] = current
            gScore[neighbor] = tentative_gScore
            temp = goal.zip(neighbor).map { _1.inject(:-) }.map(&:abs).inject(:+)
            fScore[neighbor] = tentative_gScore + temp
            puts "gScore is #{temp} for #{neighbor}" if i % 1000 == 0
            openSet << neighbor
        end  
    end
end

def embiggen(grid)
    max_x = grid.first.size
    max_y = grid.size

    grid.map! { |row| row * 5 }
    grid = grid * 5

    return grid.each_with_index.map do |row, y|
        row.each_with_index.map do |v, x|
            wrap(v, (x / max_x).floor + (y / max_y).floor)
        end
    end
end

def wrap(value, times)
    temp = (value + times)
    (temp % 10) + (temp / 10).floor
end

def reconstruct(cameFrom, current)
    total_path = []
    while current
        total_path << current
        current = cameFrom[current]
    end

    total_path.reverse
end

def cheapest(openSet, fScore)
    openSet.sort_by! {|n| fScore[n] }.first
end

def neighbors_of(point, grid)
    x, y = point
    max_x = grid.first.size - 1
    max_y = grid.size - 1

    neighbors = []
    neighbors << [x + 1, y] unless x == max_x
    neighbors << [x, y + 1] unless y == max_y
    neighbors << [x - 1, y] unless x == 0
    neighbors << [x, y - 1] unless y == 0

    neighbors
end

def value_at(point, grid)
    grid[point.last][point.first]
end

main
