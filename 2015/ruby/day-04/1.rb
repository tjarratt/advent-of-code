#!/usr/bin/env ruby

require 'digest/md5'

def main
  puts part_1
  puts part_2
end

def part_1
  0.upto(999999).each do |num|
    return num if good(num)
  end
end

def part_2
  0.upto(9999999).each do |num|
    return num if better(num)
  end
end

def good(num)
  md5 = Digest::MD5.hexdigest("iwrupvqb#{num}")
  bits = md5.split('').take(5).uniq

  bits.size == 1 && bits.first == '0'
end

def better(num)
  md5 = Digest::MD5.hexdigest("iwrupvqb#{num}")
  bits = md5.split('').take(6).uniq

  bits.size == 1 && bits.first == '0'
end

main
