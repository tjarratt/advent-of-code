#!/usr/bin/env ruby

require 'set'

def part_one
    rope = File.read('input')
               .split("\n")
               .map { parse(_1.split(' ')) }
               .reduce(Rope.new) { |rope, motion| rope.move(*motion) }

    puts rope.locations_visited.size
end

def part_two
    rope = File.read('input')
               .split("\n")
               .map { parse(_1.split(' ')) }
               .reduce(Rope.new(10)) { |rope, motion| rope.move(*motion) }

    puts rope.locations_visited.size
end

def parse(pieces)
    [pieces.first.to_sym, pieces.last.to_i]
end

class Rope
    def initialize(knots = 2)
        @head = [0, 0]
        @knots = knots.times.map { [0, 0] }

        @history = Set.new
        @history << @knots.last
    end

    def move(direction, how_much)
        how_much.times do
            move_head(@knots.first, direction)

            1.upto(@knots.size - 1).each do |index|
                @knots[index] = move_knot(@knots[index], @knots[index - 1])
            end

            @history << @knots.last
        end

        self
    end

    def locations_visited
        @history
    end

    private
    def move_head(head, where)
        case where
        when :L
            head = [head.first - 1, head.last]
        when :R
            head = [head.first + 1, head.last]
        when :U
            head = [head.first, head.last + 1]
        when :D
            head = [head.first, head.last - 1]
        end

        @knots[0] = head
    end

    def move_knot(knot, head)
        return knot if close_enough(knot, head)

        if knot.first != head.first && knot.last != head.last
            # move diagonal
            diff = [
                unit_vector(head.first - knot.first),
                unit_vector(head.last - knot.last),
            ]
            return [knot.first + diff.first, knot.last + diff.last]
        elsif knot.first == head.first
            # move up down
            return [knot.first, knot.last + unit_vector(head.last - knot.last)]
        elsif knot.last == head.last
            # move left right
            return [knot.first + unit_vector(head.first - knot.first), knot.last]
        else
            throw 'IMPOSSIBLE'
        end
    end

    def close_enough(tail, head)
        (tail.first - head.first).abs <= 1 && (tail.last - head.last).abs <= 1
    end

    def unit_vector(val)
        return 0 if val.zero?

        return val / val.abs
    end
end

part_one
part_two

