#!/usr/bin/env ruby

class Computer

    attr_reader :history

    def initialize
        @register = 1
        @history = [1]
        @instructions = []
    end

    def add_instruction(code)
        @instructions << code

        self
    end

    def compute
        @instructions.each do |instruction, arg|
            case instruction
            when :noop
                # record value of register at this cycle
                @history << @register
            when :addx
                @history << @register
                @register += arg
                @history << @register
            end
        end
    
        self
    end

    def signal_strengths_at(*cycles)
        cycles.map { |index| @history[index - 1] * index }
    end
end

puts File.read('input')
    .split("\n")
    .map { _1.match(/noop/) ? [:noop] : [:addx, _1.split(' ').last.to_i] }
    .reduce(Computer.new) { |computer, code| computer.add_instruction(code) }
    .compute
    .signal_strengths_at(20, 60, 100, 140, 180, 220)
    .inject(:+)

