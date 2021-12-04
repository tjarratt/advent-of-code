#!/usr/bin/env ruby

def main
    input, *boards = File.read("input.txt").split("\n\n")
    
    input = input.split(',').map(&:to_i)
    boards = boards.map do |b|
        raw = b.split("\n").map {|l| l.split(/\s+/).reject(&:empty?).map(&:to_i) }
        Board.new(raw)
    end
    
    input.each do |number|
        puts "next number :: #{number}"
        boards.each {|b| b.receive(number) }

        if winner = boards.find(&:won?)
            puts "winning score is #{winner.score}"
            exit
        end
    end
end

class Board
    def initialize(raw)
        @rows = raw.map {|row| row.map {|i| Item.new(i) } }
    end

    def receive(input)
        @last_input = input
        @rows.map! {|r| r.map {|i| i.receive(input); i } } 
    end

    def won?
        # check all the rows
        return true if @rows.find {|r| r.all?(&:checked) }

        # check all columns
        @rows.first.size.times do |y|
            col = []            
            @rows.each do |row|
                col << row[y]
            end

            return true if col.all?(&:checked)
        end

        false
    end

    def score
        sum =  @rows.map { |r| r.reject(&:checked) }
                    .flatten
                    .map { |i| i.value }
                    .inject(:+)

        sum * @last_input
    end

    def to_s
        @rows.map {|r| r.map(&:to_s).join(' ') }
    end
end

class Item

    attr_reader :value
    attr_reader :checked

    def initialize(value)
        @value = value
        @checked = false
    end

    def receive(input)
        @checked ||= (@value == input)
    end

    def to_s
        @value
    end
end

main
