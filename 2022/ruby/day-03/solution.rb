#!/usr/bin/env ruby
require 'set'

def main
  part_one
  part_two
end

def part_one
  # read each rucksack
  # split each into two compartments
  # find the item in both comparments
  # get priority for item
  # sum all of the priorities 

  puts File.read('input')
           .split("\n")
           .map {|line| line.split('') }
           .map {|contents| contents.each_slice(contents.size / 2).to_a }
           .map {|first, second| [Set.new(first), Set.new(second)] }
           .map {|first, second| first.intersection(second).to_a.first }
           .map {|item| priority_for(item) }
           .inject(:+)
end

def part_two
  puts File.read('input')
           .split("\n")
           .map {|line| line.split('') }
           .each_slice(3)
           .to_a
           .map {|group| group.map {|rucksack| Set.new(rucksack) } }
           .map {|group| group[0].intersection(group[1]).intersection(group[2]).to_a.first }
           .map {|item| priority_for(item) }
           .inject(:+)
end

def priority_for(item)
  if item.uppercase?
    item.ord - (?A.ord - 1) + 26
  else 
    item.ord - (?a.ord - 1)
  end 
end

class String
  def uppercase?
    self == self.upcase
  end
end

main
