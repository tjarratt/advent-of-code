#!/usr/bin/env ruby

floor = 0
index = nil

File.read('input.txt')
    .split('')
    .reject(&:nil?)
    .map { |p| case p ; when '(' then 1 ; when ')' then -1 end }
    .each_with_index { |p, i| floor += p; if (index.nil? && floor == -1); index = i; end }

puts "The solution is #{index + 1}"

