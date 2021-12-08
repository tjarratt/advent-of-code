#!/usr/bin/env ruby

def main
  unique_segments = [2,3,4,7]

  puts File.read('input.txt')
           .split("\n")
           .map {|l| l.split(' | ').last.split(' ') }
           .flatten
           .filter {|thingy| unique_segments.include? thingy.size }
           .size
end

main
