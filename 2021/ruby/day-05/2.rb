#!/usr/bin/env ruby

segments = File.read('input.txt')
                .split("\n")
                .map {|l| l.split(' -> ').map {|p| p.split(',').map(&:to_i) } }
                .partition {|b, e| b.first == e.first }
                .map {|g| g.map {|s| s.sort {|a,b| a <=> b } } }

horizontal = segments.first
vertical, diagonal = segments.last.partition {|b, e| b.last == e.last }

hash = Hash.new(0)

horizontal.each do |start, stop|
    start.last.upto(stop.last).each {|n| p = [start.first, n]; hash[p] += 1 }
end

vertical.each do |start, stop|
    start.first.upto(stop.first).each {|n| p = [n, start.last]; hash[p] += 1 }
end

diagonal.each do |start, stop|
    (stop.first - start.first + 1).times {|n| p = [start.first + n * (start.first > stop.first ? -1 : 1), start.last + n * (start.last > stop.last ? -1 : 1)]; hash[p] += 1 }
end

puts hash.to_a.filter {|_, v| v != 1 }.size

