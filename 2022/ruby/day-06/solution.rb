#!/usr/bin/env ruby

def detect_after(how_many)
    File.read('input')
         .split('')
         .each_cons(how_many)
         .each_with_index
         .filter {|chars, index| chars.uniq.size == chars.size }
         .first
         .last + how_many
end

puts detect_after(4)
puts detect_after(14)
