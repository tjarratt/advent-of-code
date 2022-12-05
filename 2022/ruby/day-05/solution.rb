#!/usr/bin/env ruby

def part_one
    head, tail = File.read('input').split("\n\n")
    cargo = head.split("\n")
                .map {|line| line.scan /(\s{4}|\[[A-Z]\])/ }
                .reject(&:empty?)
                .map {|captures| captures.map {|place| place.first.match(/\s+/) ? [] : [place.first.split('')[1]] } }
                .transpose
                .map(&:reverse)
                .map {|stack| stack.reject(&:empty?) }
    
    instructions = tail.split("\n")
                       .map {|line| line.scan /move (\d+) from (\d+) to (\d+)/ }
                       .flatten(1)
                       .map {|arr| arr.map(&:to_i) }
    
    instructions.each do |quantity, from, to|
        from, to = [from, to].map(&:pred)

        quantity.times do
            cargo[to] << cargo[from].pop
        end
    end
    
    puts cargo.map(&:last).map(&:first).join('')
end

def part_two
    head, tail = File.read('input').split("\n\n")
    cargo = head.split("\n")
                .map {|line| line.scan /(\s{4}|\[[A-Z]\])/ }
                .reject(&:empty?)
                .map {|captures| captures.map {|place| place.first.match(/\s+/) ? [] : [place.first.split('')[1]] } }
                .transpose
                .map(&:reverse)
                .map {|stack| stack.reject(&:empty?) }

    instructions = tail.split("\n")
                       .map {|line| line.scan /move (\d+) from (\d+) to (\d+)/ }
                       .flatten(1)
                       .map {|arr| arr.map(&:to_i) }

    instructions.each do |quantity, from, to|
        from, to = [from, to].map(&:pred)

        removed = cargo[from][-quantity..-1]
        quantity.times { cargo[from].pop }
        removed.each {|c| cargo[to].push(c) }
    end

    puts cargo.map(&:last).map(&:first).join('')
end

part_one
part_two
