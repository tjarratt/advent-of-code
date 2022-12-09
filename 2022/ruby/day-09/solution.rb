#!/usr/bin/env ruby

require 'set'

def part_one
    motions = File.read('input')
                  .split("\n")
                  .map { parse(_1.split(' ')) }

    rope = Rope.new
    motions.each do |dir, how_much|
        rope.move(dir, how_much)
    end

    puts rope.locations_visited.size
end

def parse(pieces)
    [pieces.first.to_sym, pieces.last.to_i]
end

class Rope
    def initialize
        @head = [0,0]
        @tail = [0,0]

        @history = Set.new
        @history << @tail
    end

    def move(where, how_much)
        how_much.times do
            move_head(where)
            move_tail(@head)
        end
    end

    def locations_visited
        @history
    end

    private
    def move_head(where)
        case where
        when :L
            @head = [@head.first - 1, @head.last]
        when :R
            @head = [@head.first + 1, @head.last]
        when :U
            @head = [@head.first, @head.last + 1]
        when :D
            @head = [@head.first, @head.last - 1]
        end
    end

    def move_tail(head)
        return if close_enough(@tail, head)

        if @tail.first != head.first && @tail.last != head.last
            # move diagonal
            diff = [
                unit_vector(head.first - @tail.first),
                unit_vector(head.last - @tail.last),
            ]
            @tail = [@tail.first + diff.first, @tail.last + diff.last]
        elsif @tail.first == head.first
            # move up down
            @tail = [@tail.first, @tail.last + unit_vector(head.last - @tail.last)]
        elsif @tail.last == head.last
            # move left right
            @tail = [@tail.first + unit_vector(head.first - @tail.first), @tail.last]
        else
            throw 'IMPOSSIBLE'
        end
        
        @history << @tail
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
