#!/usr/bin/env ruby

def main
    part_one
    part_two
end

def part_one
    start, graph = parse_into_graph(File.read('input'), 'S')
    puts traverse(start, graph)
end

def part_two
    start, graph = parse_into_graph(File.read('input'), 'E')
    puts traverse_in_reverse(start, graph)
end

def traverse(start, graph)
    nodes = [start]

    until nodes.empty? do
        next_set = []        

        nodes.each do |current|
            graph.neighbors_of(current).each do |neighbor|
                next_set << neighbor if neighbor.unvisited?

                neighbor.set_weight(current.weight + 1)

                return neighbor.weight if neighbor.value == 'E'
            end
        end

        nodes = next_set
    end

    raise Exception.new('Could not find solution')
end

def traverse_in_reverse(start, graph)
    nodes = [start]

    until nodes.empty? do
        next_set = []

        nodes.each do |current|
            graph.reverse_neighbors_of(current).each do |neighbor|
                next_set << neighbor if neighbor.unvisited?

                neighbor.set_weight(current.weight + 1)

                return neighbor.weight if neighbor.value == 'a'
            end
        end

        nodes = next_set
    end

    raise Exception.new('Could not find solution')
end

class Node
    attr_reader :value, :elevation, :coords
    attr_accessor :weight

    def initialize(value, elevation, coords)
        @value = value
        @elevation = elevation
        @coords = coords
        @weight = Float::INFINITY
    end

    def set_weight(new_weight)
        return unless new_weight < @weight

        @weight = new_weight
    end

    def unvisited?
        @weight == Float::INFINITY
    end
end

class Graph
    def initialize(rows)
        @rows = rows
    end

    def neighbors_of(current)
        result = []

        x, y = current.coords

        # add cartesian neighbors (where they exist)
        result << @rows[y][x - 1] unless x.zero?
        result << @rows[y][x + 1] unless x == @rows.first.size - 1
        result << @rows[y - 1][x] unless y.zero?
        result << @rows[y + 1][x] unless y == @rows.size - 1

        # keep only those who are at most one step higher
        result.keep_if { _1.elevation <= current.elevation + 1 }

        result
    end

    def reverse_neighbors_of(current)
        result = []

        x, y = current.coords

        # add cartesian neighbors (where they exist)
        result << @rows[y][x - 1] unless x.zero?
        result << @rows[y][x + 1] unless x == @rows.first.size - 1
        result << @rows[y - 1][x] unless y.zero?
        result << @rows[y + 1][x] unless y == @rows.size - 1

        # keep only those who are at most one step higher
        result.keep_if { current.elevation <= _1.elevation + 1 }

        result
    end
end

def parse_into_graph(raw, beginning)
    start = nil
    rows = raw.split("\n")
              .map { _1.split('') }

    rows = rows.each_with_index.map do |row, y|
        row.each_with_index.map do |char, x|
            elevation = elevation_for(char)
            node = Node.new(char, elevation, [x, y])
            start = node if char == beginning
            node
        end
    end

    start.weight = 0
    graph = Graph.new(rows)

    return [start, graph]
end

def elevation_for(char)
    case char
    when 'S'
        'a'.ord
    when 'E'
        'z'.ord
    else
        char.ord
    end
end

main
