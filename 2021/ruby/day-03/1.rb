#!/usr/bin/env ruby

h = File.read("input.txt")
        .split("\n")
        .map {|l| l.split("") }
        .transpose
        .map {|arr| arr.reduce(Hash.new(0)) {|h, l| h[l.to_i] += 1; h } }
        .map {|h| h.to_a }
        .map {|l| l.sort {|a,b| a.last <=> b.last } }
        .map {|e| e.map(&:first) }
        .reverse
        .each_with_index
        .map {|d, index| [d.first * 2 ** index, d.last * 2 ** index] }
        .reduce({gamma: 0, epsilon: 0}) {|h, e| h[:gamma] += e.last; h[:epsilon] += e.first; h }

puts h[:gamma] * h[:epsilon]

