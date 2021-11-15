#!/usr/bin/env ruby

def good(str)
  
  has_double = false
  pieces = str.split('')
  pieces.each_with_index do |char, index|
    has_double ||= char == pieces[index + 2]
  end

  has_repeat = false
  pieces.each_with_index do |char, index|
    break if index == pieces.size - 2

    nxt = pieces[index + 1]
    has_repeat ||= str[(index + 2)..].match? "#{char}#{nxt}"
  end

  has_repeat && has_double
end

def test(str)
  puts "#{str} : #{good(str)}"
end

puts File.read("input.txt")
         .split("\n")
         .filter {|str| good(str) }
         .size

