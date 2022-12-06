#!/usr/bin/env ruby

puts File.read('input')
         .split('')
         .each_cons(4)
         .each_with_index
         .filter {|chars, index| chars.uniq.size == chars.size }
         .first
         .last + 4
