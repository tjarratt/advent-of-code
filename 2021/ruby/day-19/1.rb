#!/usr/bin/env ruby

require 'set'

def main
    # parse the homework
    # categorize h[1]
    # for each element in h[0]
    # categorise and intersect with h[1]
    # declare success iff size == 11
    h = parse(File.read('sample-report.txt'))

    # h.each do |k, v|
    #     puts "#{k} has #{v.size}"
    # end

    seen = Set.new
    result = Set.new(h[0])
    h.keys.permutation(2).to_a.map(&:sort).uniq.each do |first, second|
        break if seen.any?
        
        find_beacons_in_common(h[first].clone, h[second].clone).each { seen << first; seen << second; result.add(_1) }
    end

    # [x] add everything to result from scanner0
    # [x] map all of the beacons from scanner1
    # [x] use that composite map to do the remaining
    
    remaining = h.keys - seen.to_a
    while remaining.any?
        remaining.each do |key|
            puts "looking to solve #{key} with composite #{result.size} beacons"
       
            find_beacons_in_common(result.to_a, h[key].clone).each { seen << key; result.add(_1) }
            remaining = remaining - seen.to_a
            puts "seen is now #{seen.to_a.inspect}"
        end
    end 
    
    puts "we found #{result.size} beacons"
end

def find_beacons_in_common(composite, beacons)
    categorised = categorise(composite)
    goal = Set.new(categorised.map(&:last))

    # puts "goal #{goal.sort.take(5).inspect}"

    beacons.each do |thingy|
        collection = beacons - thingy
        collection.unshift(thingy)

        permutations(collection).each_with_index do |permuted, count|
            eep = categorise(permuted).map(&:last)
            set = Set.new(eep)
            intersection = set.intersection(goal)
            # puts eep.sort.take(5).inspect

            if intersection.size >= 11
                toto = categorised.last
                tata = categorise(permuted).find { _1.last == toto.last }
                progress = toto.first.zip(tata.first)
                scanner = progress.each_with_index.map {|arr, i| arr.inject(:-) }
                mapd_it = (scanner.zip(thingy).each_with_index.map do |arr, i|
                    op = toto.last[i].positive? ? :+ : :-
                    arr.inject(op)
                end)

                puts "booyah the scanner is at #{scanner.inspect}"
                puts "s1 coords ? #{thingy.inspect}"
                puts "s0 coords ? #{mapd_it.inspect}"

                return (beacons.map do |beacon|
                    scanner.zip(beacon).each_with_index.map do |arr, i|
                        op = toto.last[i].positive? ? :+ : :-
                        arr.inject(op)
                    end
                end)
            end
        end
    end

    puts "DOGS BOLLOCKS"
    sleep 0.5
    
    []
end

def reverse(which, beacon)
    case which
    when 1
        beacon
    when 2
        rotate_z(rotate_z(rotate_z(beacon)))
    when 3
        rotate_z(rotate_z(beacon))
    when 4
        rotate_z(beacon)
    when 5
        rotate_y(rotate_y(rotate_y(beacon)))
    when 6
        rotate_y(rotate_y(rotate_y(rotate_z(rotate_z(rotate_z(beacon))))))
    when 7
        rotate_y(rotate_y(rotate_y(rotate_z(rotate_z(beacon)))))
    when 8
        rotate_y(rotate_y(rotate_y(rotate_z(beacon))))
    when 9
        rotate_y(rotate_y(beacon))
    when 10
        rotate_y(rotate_y(rotate_z(rotate_z(rotate_z(beacon)))))
    when 11
        rotate_y(rotate_y(rotate_z(rotate_z(beacon))))
    when 12
        rotate_y(rotate_y(rotate_z(beacon)))
    when 13
        rotate_y(beacon)
    when 14
        rotate_y(rotate_z(rotate_z(rotate_z(beacon))))
    when 15
        rotate_y(rotate_z(rotate_z(beacon)))
    when 16
        rotate_y(rotate_z(beacon))
    when 17
        rotate_x(rotate_x(rotate_x(beacon)))
    when 18
        rotate_x(rotate_x(rotate_x(rotate_z(rotate_z(rotate_z(beacon))))))
    when 19
        rotate_x(rotate_x(rotate_x(rotate_z(rotate_z(beacon)))))
    when 20
        rotate_x(rotate_x(rotate_x(rotate_z(beacon))))
    when 21
        rotate_x(beacon)
    when 22
        rotate_x(rotate_z(rotate_z(rotate_z(beacon))))
    when 23
        rotate_x(rotate_z(rotate_z(beacon)))
    when 24
        rotate_x(rotate_z(beacon))
    end
end


def permutations(beacon)
    result = []
    result << beacon 
    result << beacon.map { rotate_z(_1) }
    result << beacon.map { rotate_z(rotate_z(_1)) }
    result << beacon.map { rotate_z(rotate_z(rotate_z(_1))) }

    result << beacon.map { rotate_y(_1) }
    result << beacon.map { rotate_z(rotate_y(_1)) }
    result << beacon.map { rotate_z(rotate_z(rotate_y(_1))) }
    result << beacon.map { rotate_z(rotate_z(rotate_z(rotate_y(_1)))) }

    result << beacon.map { rotate_y(rotate_y(_1)) }
    result << beacon.map { rotate_z(rotate_y(rotate_y(_1))) }
    result << beacon.map { rotate_z(rotate_z(rotate_y(rotate_y(_1)))) }
    result << beacon.map { rotate_z(rotate_z(rotate_z(rotate_y(rotate_y(_1))))) }

    result << beacon.map { rotate_y(rotate_y(rotate_y(_1))) }
    result << beacon.map { rotate_z(rotate_y(rotate_y(rotate_y(_1)))) }
    result << beacon.map { rotate_z(rotate_z(rotate_y(rotate_y(rotate_y(_1))))) }
    result << beacon.map { rotate_z(rotate_z(rotate_z(rotate_y(rotate_y(rotate_y(_1)))))) }

    result << beacon.map { rotate_x(_1) }
    result << beacon.map { rotate_z(rotate_x(_1)) }
    result << beacon.map { rotate_z(rotate_z(rotate_x(_1))) }
    result << beacon.map { rotate_z(rotate_z(rotate_z(rotate_x(_1)))) }

    result << beacon.map { rotate_x(rotate_x(rotate_x(_1))) }
    result << beacon.map { rotate_z(rotate_x(rotate_x(rotate_x(_1)))) }
    result << beacon.map { rotate_z(rotate_z(rotate_x(rotate_x(rotate_x(_1))))) }
    result << beacon.map { rotate_z(rotate_z(rotate_z(rotate_x(rotate_x(rotate_x(_1)))))) }

    raise 'zomg' unless result.to_set.size == 24

    result
    # identity
    # rotate z
    # rotate z rotate z
    # rotate_z rotate_z rotate_z
 
    # flip_y
    # flip_y rotate_z
    # flip_y rotate_z rotate_z
    # flip_y rotate_z rotate_z rotate_z

    # flip_y flip_y
    # flip_y flip_y rotate_z
    # flip_y flip_y rotate_z rotate_z
    # flip_y flip_y rotate_z rotate_z rotate_z

    # flip_y flip_y flip_y
    # flip_y flip_y flip_y rotate_z
    # flip_y flip_y flip_y rotate_z rotate_z
    # flip_y flip_y flip_y rotate_z rotate_z rotate_z
    
    # flip_x
    # flip_x rotate_z
    # flip_x rotate_z rotate_z
    # flip_x rotate_z rotate_z rotate_z
    
    # flip_x flip_x flip_x
    # flip_x flip_x flip_x rotate_z
    # flip_x flip_x flip_x rotate_z rotate_z
    # flip_x flip_x flip_x rotate_z rotate_z rotate_z
end

def flip_x(beacon)
    [beacon[0], -beacon[1], -beacon[2]]
end

def rotate_x(beacon)
    [beacon[0], beacon[2], -beacon[1]]
end

def flip_y(beacon)
    [-beacon[0], beacon[1], -beacon[2]]
end

def rotate_y(beacon)
    [-beacon[2], beacon[1], beacon[0]]
end

def flip_z(beacon)
    [-beacon[0], -beacon[1], beacon[2]]
end

def rotate_z(beacon)
    [-beacon[1], beacon[0], beacon[2]]
end

def parse_beacons(raw)
    raw.map { _1.split(',').map(&:to_i) }
end

def categorise(input)
    copy = input.clone
    first = copy.shift
    copy.map {    [_1, first.zip(_1)] }
        .map {|z| [z[0], z[1].map { _1.inject(:-) } ] }
end

def parse(input)
    input.split("\n\n")
         .to_h do 
            head, *rest = _1.split("\n")
            [head.split(' ')[2].to_i, parse_beacons(rest)]
         end
end

main
