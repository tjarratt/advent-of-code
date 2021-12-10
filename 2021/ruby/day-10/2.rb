#!/usr/bin/env ruby

def main
    opens  = ['[', '{', '(', '<']
    closes = [']', '}', ')', '>']

    completions = []
    completions = File.read('input.txt')
        .split("\n")
        .map { _1.split('') }
        .map do |line|
            stack = []
            corrupted = false
            line.each do |char|
                if opens.include?(char)
                    stack << char
                elsif char_closes?(char, stack)
                    stack.pop
                else
                    corrupted = true
                    break
                end
            end
            [corrupted, stack]
        end
        .reject {|corrupted, _| corrupted }
        .map {|_, stack| stack }
        .map { _1.reverse }
        .map { _1.map {|m| closes[opens.index(m)] } }

    puts completions.map! { score(_1) }
                    .sort!
                    .at(completions.size.pred / 2)
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
