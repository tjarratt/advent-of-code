#!/usr/bin/env ruby

calories = File.read("input.txt")
                .split("\n\n")
                .map {|l| l.split("\n").map(&:to_i).inject(:+) }


puts "part 1 solution is : #{calories.sort.last}"
puts "part 2 solution is : #{calories.sort[-3..-1].inject(:+)}"


