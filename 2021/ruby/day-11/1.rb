#!/usr/bin/env ruby

def main
    grid = File.read('input.txt')
               .split("\n")
               .map { _1.split('').map(&:to_i) }

    pp(grid)  

    flashes = 0 
    100.times do |round|
        grid.each_with_index do |row, y|
            row.each_with_index do |oct, x|
                grid[y][x] += 1
            end
        end

        flashed = []
        octopi = flashing(grid)
        while octopi.any?
            octopi.each do |x, y|
                flashed << [x, y]
                flashes += 1

                neighbors(grid, x, y).each do |nx, ny|
                    next if flashed.include? [nx, ny]
                    grid[ny][nx] += 1
                end
            end 

            octopi = flashing(grid) - flashed
        end

        flashed.each do |x, y|
            grid[y][x] = 0
        end

        pp(grid)
    end

    puts flashes
end

def pp(grid)
    grid.each do |line|
        puts line.join(' ')
    end

    puts
end

def neighbors(grid, x, y)
    neighbors = []
    neighbors << [x - 1, y] unless x == 0
    neighbors << [x + 1, y] unless x == grid.first.size - 1
    neighbors << [x, y - 1] unless y == 0
    neighbors << [x, y + 1] unless y == grid.size - 1
    
    neighbors << [x - 1, y - 1] unless x == 0 or y == 0
    neighbors << [x - 1, y + 1] unless x == 0 or y == grid.size - 1
    neighbors << [x + 1, y - 1] unless x == grid.first.size - 1 or y == 0
    neighbors << [x + 1, y + 1] unless x == grid.first.size - 1 or y == grid.size - 1

    neighbors
end

def flashing(grid)
    results = []
    grid.each_with_index do |row, y|
        row.each_with_index do |octo, x|
            results << [x, y] if octo > 9
        end
    end

    results
end

main
