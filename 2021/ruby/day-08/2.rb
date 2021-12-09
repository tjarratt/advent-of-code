#!/usr/bin/env ruby

require 'set'

def main
    display_lookup = {
        arr('abcefg') => 0, 
        arr('cf') => 1, 
        arr('acdeg') => 2, 
        arr('acdfg') => 3, 
        arr('bcdf') => 4, 
        arr('abdfg') => 5, 
        arr('abdefg') => 6, 
        arr('acf') => 7, 
        arr('abcdefg') => 8, 
        arr('abcdfg') => 9, 
    }

    
    lines = File.read('input.txt')
                .split("\n")
                .map {|l| l.split(' | ').map {|s| s.split(' ') } }

    sum = 0
    lines.each do |line|
        input = line.first
        readings = line.last.map {|r| r.split('').sort }
        signal_to_key = Hash.new
   
        signal_1 = arr(input.find {|i| i.size == 2})
        signal_7 = arr(input.find {|i| i.size == 3 })
        signal_to_key['a'] = diff(signal_1, signal_7)

        signal_4 = arr(input.find {|i| i.size == 4 })
        signal_3 = arr(input.find do |i|
            i.size == 5 and
            arr(i).include? signal_7[0] and
            arr(i).include? signal_7[1] and
            arr(i).include? signal_7[2]
        end)
        signal_to_key['b'] = diff(signal_3, signal_4)
        signal_to_key['g'] = (signal_3 - signal_7 - signal_4).first
        signal_to_key['d'] = (signal_4 - signal_7 - [diff(signal_3, signal_4)]).first

        signal_5 = arr(input.find do |i|
            i.size == 5 and
            arr(i).include?(signal_to_key['a']) and
            arr(i).include?(signal_to_key['b']) and
            arr(i).include?(signal_to_key['d']) and
            arr(i).include?(signal_to_key['g'])
        end)

        signal_to_key['f'] = signal_5.filter {|s| !signal_to_key.value?(s) }.first
        signal_to_key['c'] = signal_3.filter {|s| !signal_to_key.value?(s) }.first
        signal_to_key['e'] = (arr('abcdefg') - signal_to_key.values).first

        solution_map = display_lookup.map do |k, v|
            [k.map {|t| signal_to_key[t]}.sort, v.to_s] 
        end.to_h

        result = readings.map {|r| solution_map[r] }.join('')
        sum += result.to_i

        # THIS IS A STRATEGY
        # identify (1) which gives us {c, f}
        # identify (7) which gives us {a, c, f}
            # solve for A
        # identify (4) 
        # identify (3) by looking for (7) + one letter from (4)
            # solve for G by finding the extra letter in (3)
            # solve for B by finding what is in (4) but not in (7)
            # solve for D by elimination
        # identify (5) by looking for ABDFG
            # solve for F
        # identify (3) by looking for ACDFG
            # solve for C
        # solve E by elimination
    end
    puts sum
end

def arr(str)
    str.split('').sort
end

def diff(first, second)
    return Set.new(second).difference(Set.new(first)).first
end

main
