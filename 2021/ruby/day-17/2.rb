#!/usr/bin/env ruby

def main(input)
    range =  input.split(': ')
                  .last
                  .split(', ')
                  .map { _1.split('=').last }
                  .map { eval _1 }

    feasible = 0
    -100.upto(100).each do |y|
        1000.times do |x|
            velocity = [x, y]
            next if velocity == [0, 0]
            break if invalid?(velocity, range)

            feasible += 1 if simulate(velocity, range)
        end

    end

    puts feasible
end

def invalid?(velocity, range)
    velocity.first > range.first.max
end

def simulate(velocity, range)
    pos = [0, 0]
    until pos.first > range.first.max or pos.last < range.last.min
        pos, velocity = tick(pos, velocity)
        return true if contains?(range, pos)
    end

    return false
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
