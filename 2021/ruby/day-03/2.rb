#!/usr/bin/env ruby

def main
    data = File.read("input.txt")
            .split("\n")
            .map {|l| l.split("").map(&:to_i) }
            .transpose

    oxygen = oxygen_generator_rating(data.clone)
    co_scrubber = co_scrubber_rating(data.clone)

    puts "oxygen rating is #{oxygen}"
    puts "co2 rating is #{co_scrubber}"

    puts oxygen * co_scrubber
end

def co_scrubber_rating(data)
    index = 0
    while index < data.length
        row = data[index]
        mc = least_common(row, 0)

        # filter out columns whose value matches this one
        data.map! do |r|
            r.each_with_index.map {|item, i| row[i] == mc ? item : nil }.reject(&:nil?) 
        end

        # break if we have a single one
        break if data.size == 1
        
        index += 1
    end

    data.flatten.reverse.each_with_index.map {|d, i| d * 2 ** i }.reduce(&:+)

end

def oxygen_generator_rating(data)
    index = 0
    while index < data.length
        row = data[index]
        mc = most_common(row, 1)

        # filter out columns whose value matches this one
        data.map! do |r|
            r.each_with_index.map {|item, i| row[i] == mc ? item : nil }.reject(&:nil?) 
        end

        # break if we have a single one
        break if data.size == 1
        
        index += 1
    end

    data.flatten.reverse.each_with_index.map {|d, i| d * 2 ** i }.reduce(&:+)
end

def most_common(row, default)
    freq = row.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

    return default if freq[1] == freq[0]
    row.max_by {|v| freq[v] }
end

def least_common(row, default)
    freq = row.inject(Hash.new(0)) { |h,v| h[v] += 1; h }

    return default if freq[1] == freq[0]
    row.min_by {|v| freq[v] }
end

main
