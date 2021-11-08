#!/usr/bin/env ruby

puts File.read('input.txt')
         .split("\n")
         .reject(&:nil?)
         .map {|line| line.split("x").map(&:to_i).sort }
         .map {|a, b, c| 2 * a + 2 * b + a*b*c }
         .inject(:+)

