#!/usr/bin/env ruby

calories = File.read("input.txt")
                .split("\n\n")
                .map {|l| l.split("\n").map(&:to_i).inject(:+) }

puts calories.sort.last
