#!/usr/bin/env ruby

def main(input)
    range =  input.split(': ')
                  .last
                  .split(', ')
                  .map { _1.split('=').last }
                  .map { eval _1 }

    y_positions = []
    100.times do |y|
        1000.times do |x|
            velocity = [x, y]
            next if velocity == [0, 0]
            break if invalid?(velocity, range)

            valid, highest_y = simulate(velocity, range)
            y_positions << highest_y if valid
        end

    end

    puts y_positions.sort.last
end

def invalid?(velocity, range)
    velocity.first > range.first.max
end

def simulate(velocity, range)
    initial = velocity.clone
    pos = [0, 0]
    max_y = -Float::INFINITY
    until pos.first > range.first.max or pos.last < range.last.min
        pos, velocity = tick(pos, velocity)
        max_y = [max_y, pos.last].max
        if contains?(range, pos)
            return [true, max_y]
        end
    end

    return [false, -1]
end

def tick(pos, velocity)
    new_pos = [pos.first + velocity.first, pos.last + velocity.last]
    new_velocity = [[velocity.first - 1, 0].max, velocity.last - 1]
   
    [new_pos, new_velocity] 
end

def contains?(range, pos)
    range.first.include? pos.first and 
    range.last.include? pos.last
end

#main('target area: x=20..30, y=-10..-5')
main('target area: x=269..292, y=-68..-44')
