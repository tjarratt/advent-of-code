#!/usr/bin/env ruby

def main
    hash = Hash.new
    File.read('input.txt')
        .split("\n").map {|l| l.match(/^([a-z ]+) (\d+),(\d+) through (\d+),(\d+)/) }
        .each do |match|
            lower, upper = bounds(match[2], match[3], match[4], match[5])
            puts "perform '#{match[1]}' from #{lower} to #{upper}"
            case match[1]
            when 'turn on' then
                x = lower.first
                while x <= upper.first
                    y = lower.last
                    while y <= upper.last
                        hash[[x, y]] = true
                        y += 1
                    end
                    x += 1
                end
            when 'turn off' then
                x = lower.first
                while x <= upper.first
                    y = lower.last
                    while y <= upper.last
                        hash[[x, y]] = false
                        y += 1
                    end
                    x += 1
                end
            when 'toggle' then
                x = lower.first
                while x <= upper.first
                    y = lower.last
                    while y <= upper.last
                        hash[[x, y]] = !hash[[x, y]]
                        y += 1
                    end
                    x += 1
                end
            else
                raise "Unexpected arg #{match[1]}"
            end 
        end
    puts hash.values.filter {|v| v == true }.size
end

def bounds(x1, y1, x2, y2)
    [
        [x1.to_i, y1.to_i],
        [x2.to_i, y2.to_i],
    ]
end

main
