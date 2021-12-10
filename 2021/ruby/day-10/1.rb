#!/usr/bin/env ruby

def main
    opens  = ['[', '{', '(', '<']
    closes = [']', '}', ')', '>']

    scoring = {')'=> 3, ']'=> 57, '}'=> 1197, '>'=> 25137}

    corrupted = []
    File.read("input.txt")
        .split("\n")
        .each do |line|
            stack = []
            line.split('').each do |char|
                if opens.include?(char)
                    stack << char
                elsif char_closes?(char, stack)
                    stack.pop
                else
                    corrupted << scoring[char]
                    break
                end
            end
        end
    
    puts corrupted.inject(:+)
end

def char_closes?(char, stack)
    case [stack.last, char]
    when ['(', ')'] then
        true
    when ['[', ']'] then
        true
    when ['{', '}'] then
        true
    when ['<', '>'] then
        true
    else
        false
    end
end

main
