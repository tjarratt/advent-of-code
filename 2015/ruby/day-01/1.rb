#!/usr/bin/env ruby

puts File.read('input.txt')
         .split('')
         .reject(&:nil?)
         .map { |p| case p ; when '(' then 1 ; when ')' then -1 end }
         .inject(:+)

