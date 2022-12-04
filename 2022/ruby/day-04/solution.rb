#!/usr/bin/env ruby

require 'set'

def part_one
    result = File.read('input')
                 .split("\n")
                 .map {|line| line.split(',')
                                  .map {|range| from, to = range.split('-'); from.upto(to).to_a.to_set } }
                 .inject(0) {|sum, pair| sum += 1 if pair.first.subset?(pair.last) or pair.last.subset?(pair.first); sum }
    
    puts result
end

part_one
