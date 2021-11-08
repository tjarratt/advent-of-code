#!/usr/bin/env ruby

puts File.read('input.txt')
         .split("\n")
         .reject(&:nil?)
         .map {|line| line.split("x").map(&:to_i) }
         .map {|l, w, h| [l*w, w*h, h*l] }
         .map {|arr| arr << arr.min }
         .map {|l, w, h, spare| [l*2, w*2, h*2, spare].inject(:+) }
         .inject(:+)

