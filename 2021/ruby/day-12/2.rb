#!/usr/bin/env ruby

def main
    graph = File.read('input.txt')
                .split("\n")
                .map { _1.split('-') }
                .inject(Hash.new) { |hash, path| hash[path[0]] ||= []; hash[path[1]] ||= []; hash[path.first] << path.last; hash[path.last] << path.first; hash}

    graph.delete('end')

    paths = []
    completed = []
    paths << [['start'], graph['start']]

    while paths.any? {|p| p.last.any? }
        new_paths = []
        paths.filter {|p| p.last.any? }.each do |path, choices|
            choices.each do |choice|
                next unless valid_choice?(choice, path)

                clone = path.clone
                clone << choice
                new_paths << [clone, graph[choice] || Array.new]
            end
        end

        completed << new_paths.filter {|path, choices| choices.empty? }
        paths = new_paths
    end

    completed.reject!(&:empty?)
    completed.flatten!(1)
    completed.uniq!

    puts completed.size
end

def valid_choice?(choice, path)
    return false if choice == 'start'
    return true if choice.match /[A-Z]+/
    return true if (path.count(choice) == 1 and
                    path.filter { _1.match /[a-z]+/ }.none? {|p| path.count(p) == 2 })
    
    return !path.include?(choice)
end

main
