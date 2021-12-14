#!/usr/bin/env ruby

polymer, rules = File.read('input.txt')
                     .split("\n\n")

rules = rules.split("\n")
             .map { _1.split(' -> ') }
             .to_h


10.times do 
    polymer = polymer.split('')
                     .each_cons(2)
                     .map {|a, b| [a, rules[a + b]].compact }
                     .flatten
                     .join('') + polymer.split('').last
end

counts = polymer.split('')
                .inject(Hash.new(0)) { |h, c| h[c] += 1; h }
                .to_a
                .sort_by(&:last)
                .map(&:last)

puts counts.last - counts.first

