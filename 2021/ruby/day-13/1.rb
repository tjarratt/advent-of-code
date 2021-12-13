#!/usr/bin/env ruby

def main
    lines, instructions = 
        File.read('input.txt')
            .split("\n\n")

    points = lines.split("\n")
                  .map { _1.split(',').map(&:to_i) }
                  .to_h {|p| [p, true] }

    instructions.split("\n").each_with_index do |fold, i|
        break if i >= 1 # testing

        axis = fold.split('=').last.to_i

        case fold
        when /fold along x/ then
            points.filter {|p, _| p.first > axis }
                  .map {|p, _| 
                        points.delete(p); 
                        fold_left(p, axis); 
                       }
                  .each {|p| points[p] = true }

        when /fold along y/ then
            points.filter {|p, _| p.last > axis }
                  .map {|p, _| 
                        points.delete(p); 
                        fold_up(p, axis);
                       }
                  .each {|p| points[p] = true }
        end

    end

    puts points.keys.size
end

def fold_up(point, axis)
    [point.first, axis - (point.last - axis)]
end

def fold_left(point, axis)
    [axis - (point.first - axis), point.last] 
end

main
