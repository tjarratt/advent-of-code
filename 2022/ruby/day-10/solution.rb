#!/usr/bin/env ruby

class Computer

    attr_reader :history

    def initialize
        @register = 1
        @history = [1]
        @instructions = []

        @screen = []
    end

    def add_instruction(code)
        @instructions << code

        self
    end

    def compute
        @instructions.each do |instruction, arg|
            draw_pixel
            case instruction
            when :noop
                # record value of register at this cycle
                @history << @register
            when :addx
                @history << @register
                draw_pixel

                @register += arg
                @history << @register
            end

        end
    
        self
    end

    def signal_strengths_at(*cycles)
        cycles.map { |index| @history[index - 1] * index }
    end

    def print_screen
        @screen.map { _1.join('') }.join("\n")
    end

    private
    def draw_pixel
        @screen << [] if cycle % 40 == 0
        @screen.last << (((@register - cycle % 40).abs <= 1) ? '#' : '.')
    end

    def cycle
        @history.size.pred
    end
end

computer = File.read('input')
    .split("\n")
    .map { _1.match(/noop/) ? [:noop] : [:addx, _1.split(' ').last.to_i] }
    .reduce(Computer.new) { |computer, code| computer.add_instruction(code) }
    .compute

# part one
puts computer.signal_strengths_at(20, 60, 100, 140, 180, 220).inject(:+)

# part two
puts computer.print_screen

