#!/usr/bin/env ruby

def good(str)
  return false unless str.split('').filter {|c| c.match /a|e|i|o|u/ }.size >= 3

  return false if str.match /ab/
  return false if str.match /cd/
  return false if str.match /pq/
  return false if str.match /xy/
  
  has_double = false
  pieces = str.split('')
  pieces.each_with_index do |char, index|
    has_double ||= char == pieces[index + 1]
  end

  has_double
end

puts File.read("input.txt")
         .split("\n")
         .filter {|str| good(str) }
         .size

