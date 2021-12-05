#!/usr/bin/env ruby

segments = File.read('input.txt')
                .split("\n")
                .map {|l| l.split(' -> ').map {|p| p.split(',').map(&:to_i) } }
                .filter {|b, e| b.first == e.first or b.last == e.last }
                .partition {|b, e| b.first == e.first }
                .map {|g| g.map {|s| s.sort {|a,b| a <=> b } } }

hash = Hash.new(0)

segments.first.each do |start, stop|
    start.last.upto(stop.last).each {|n| p = [start.first, n]; hash[p] += 1 }
end

segments.last.each do |start, stop|
    start.first.upto(stop.first).each {|n| p = [n, start.last]; hash[p] += 1 }
end

puts hash.to_a.filter {|_, v| v == 2 }.size

