#!/usr/bin/env ruby

def main
    polymer, rules = File.read('input.txt')
                         .split("\n\n")
    
    rules = rules.split("\n")
                 .map { _1.split(' -> ') }
                 .to_h
    
    counts = Hash.new(0)
    polymer.split('').each_cons(2).each do |first, last|
        counts[first + last] += 1
    end
    
    40.times do |round|
        temp = Hash.new(0)
        counts.each do |key, value|
            nucleotides = key.split('')
    
            temp[nucleotides[0] + rules[key]] += value
            temp[rules[key] + nucleotides[1]] += value
        end
        counts = temp
    end
   
    count_letters(counts).to_a
                         .map(&:last)
                         .sort                          # WHYYYYY
                         .tap {|a| puts a.last - a.first + 1 }
end

def count_letters(hash)
    result = Hash.new(0)
    hash.to_a.each do |k, v|
        pieces = k.split('')
        result[pieces.first] += v
    end

    result
end

main
