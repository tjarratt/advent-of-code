#!/usr/bin/env ruby

require 'set'

def main
    grid = File.read('input.txt')
               .split("\n")
               .map { _1.split('').map(&:to_i) }

    start = [0, 0]
    goal = [grid.first.size - 1, grid.size - 1]

    puts a_star(grid, start, goal)
                .map { value_at(_1, grid) }
                .drop(1)
                .inject(:+)
end
  
def a_star(grid, start, goal) 
    gScore = Hash.new(Float::INFINITY)
    gScore[[0, 0]] = 0
    
    fScore = Hash.new(Float::INFINITY)
    fScore[[0, 0]] = 0
    
    cameFrom = Hash.new
    openSet = Set.new.add([0, 0])
    
    while openSet.any?
        current = cheapest(openSet, fScore)
        if current == goal 
            return reconstruct(cameFrom, current)
        end

        openSet.delete(current)

        neighbors_of(current, grid).each do |neighbor|
            tentative_gScore = gScore[current] + value_at(neighbor, grid)
            next unless tentative_gScore < gScore[neighbor]

            cameFrom[neighbor] = current
            gScore[neighbor] = tentative_gScore
            fScore[neighbor] = tentative_gScore + value_at(neighbor, grid)
            openSet.add(neighbor)
        end  
    end
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
    openSet.to_a.sort_by {|n| fScore[n] }.first
end

def neighbors_of(point, grid)
    x, y = point
    max_x = grid.first.size - 1
    max_y = grid.size - 1

    neighbors = []
    neighbors << [x + 1, y] unless x == max_x
    neighbors << [x, y + 1] unless y == max_y

    neighbors
end

def value_at(point, grid)
    grid[point.last][point.first]
end

main
