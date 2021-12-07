#!/usr/bin/env ruby

input = File.read('test.txt')
            .split(',')
            .map(&:to_i)

puts (0..input.max).map {|p| [p, input.map {|i| (i - p).abs }.inject(:+)] }.sort { |a, b| a.last <=>
 b.last }.first
