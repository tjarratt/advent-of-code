#!/usr/bin/env ruby

input = File.read("input.txt").split(",").map(&:to_i)
hash = Hash.new(0)
input.each {|fish| hash[fish] += 1 }

256.times do |round|
    generation = Hash.new(0)
    hash.each do |key, value|
        if key == 0
            generation[6] += value
            generation[8] += value
        else
            generation[key - 1] += value
        end
    end

    hash = generation
end

puts hash.reduce(0) {|acc, tuple| acc + tuple.last }

