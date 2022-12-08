#!/usr/bin/env ruby

require 'set'

class Tree
    attr_reader :height
 
    def initialize(height)
        @height = height
        @occlusions = Set.new    
    end

    def occluded(dir)
        @occlusions.add(dir)
    end

    def visible?
        @occlusions.size < 4
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

part_one
