#!/usr/bin/env ruby

def main
    input = File.read('input.txt')
                .split(',')
                .map(&:to_i)
    
    puts (0..input.max)
                    .map {|p| [p, input.map {|i| _sum(i, p) }.inject(:+) ]}
                    .sort { |a, b| a.last <=> b.last }
                    .first

end

def _sum(first, last)
    first, last = [first, last].sort
    range = (first...last)

    range.size * (last - first + 1) / 2
end

main
