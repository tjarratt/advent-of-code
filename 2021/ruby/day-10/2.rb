#!/usr/bin/env ruby

def main
    opens  = ['[', '{', '(', '<']
    closes = [']', '}', ')', '>']

    completions = []
    File.read("input.txt")
        .split("\n")
        .each do |line|
            stack = []
            corrupted = false
            line.split('').each do |char|
                if opens.include?(char)
                    stack << char
                elsif char_closes?(char, stack)
                    stack.pop
                else
                    corrupted = true
                    break
                end
            end

            completions << stack.reverse.map do |missing|
                closes[opens.index(missing)]
            end unless corrupted
        end

    completions.map! {|c| score(c) }.sort!
    puts completions[completions.size.pred / 2]
end

def score(completions) 
    scoring = {')'=> 1, ']'=> 2, '}'=> 3, '>'=> 4}
    
    sum = 0
    completions.each do |char|
        sum *= 5
        sum += scoring[char]
    end

    sum
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
