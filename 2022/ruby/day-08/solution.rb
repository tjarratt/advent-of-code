#!/usr/bin/env ruby

require 'set'

class Tree
    attr_reader :height
 
    def initialize(height)
        @height = height
        @occlusions = Set.new
        @visibilities = Hash.new
    end

    def occluded(dir)
        @occlusions.add(dir)
    end

    def visible?
        @occlusions.size < 4
    end

    def can_see(direction, how_many)
        @visibilities[direction] = how_many 
    end

    def scenic_score
        @visibilities.values.inject(:*)
    end
end

def part_one
    grid = File.read('input')
               .split("\n")
               .map { _1.split('').map(&:to_i).map { |value| Tree.new(value) } }
    
    forest = Set.new
    0.upto(grid.size - 1) do |y|
        seen = []
        0.upto(grid.first.size - 1) do |x|
            tree = grid[y][x]
            tree.occluded(:left) if seen.any? { _1 >= tree.height }
    
            seen << tree.height
            forest << tree
        end
    
        seen = []
        (grid.first.size - 1).downto(0) do |x|
            tree = grid[y][x]
            tree.occluded(:right) if seen.any? { _1 >= tree.height }
    
            seen << tree.height
            forest << tree
        end
    end
    
    0.upto(grid.first.size - 1) do |x|
        seen = []
        0.upto(grid.size - 1) do |y|
            tree = grid[y][x]
            tree.occluded(:top) if seen.any? { _1 >= tree.height }
    
            seen << tree.height
            forest << tree
        end
    
        seen = []
        (grid.size - 1).downto(0) do |y|
            tree = grid[y][x]
            tree.occluded(:bottom) if seen.any? { _1 >= tree.height }
    
            seen << tree.height
            forest << tree
        end
    end
    
    puts forest.filter(&:visible?).size
end

def part_two
    grid = File.read('input')
               .split("\n")
               .map { _1.split('').map(&:to_i).map { |value| Tree.new(value) } }
    
    forest = Set.new
    0.upto(grid.size - 1) do |y|
        0.upto(grid.first.size - 1) do |x|
            tree = grid[y][x]

            how_many = 0
            (x-1).downto(0) do |dx|
                how_many += 1
                break if grid[y][dx].height >= tree.height
            end
            tree.can_see(:left, how_many)

            how_many = 0
            (x+1).upto(grid.first.size - 1) do |dx|
                how_many += 1
                break if grid[y][dx].height >= tree.height
            end
            tree.can_see(:right, how_many)

            how_many = 0
            (y-1).downto(0) do |dy|
                how_many += 1
                break if grid[dy][x].height >= tree.height
            end
            tree.can_see(:top, how_many)

            how_many = 0
            (y+1).upto(grid.size - 1) do |dy|
                how_many += 1
                break if grid[dy][x].height >= tree.height
            end
            tree.can_see(:bottom, how_many)

            forest << tree
        end
    end

    puts forest.map(&:scenic_score).sort.last
end

part_one
part_two
