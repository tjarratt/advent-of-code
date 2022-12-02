#!/usr/bin/env ruby

def main
  part_one
  part_two
end

def part_one
  score = File.read("input")
              .split("\n")
              .map { |line| determine_round(*line.split(' ')) }
              .inject(:+)
  
  puts "solution for part 1 is #{score}"
end

def part_two
  score = File.read("input")
              .split("\n")
              .map { |line| line.split(' ') }
              .map { |plays| decide_how_to_play(*plays) }
              .map { |plays| determine_round(*plays) }
              .inject(:+)
  
  puts "solution for part 1 is #{score}"
end

def decide_how_to_play(opponent, strategy)
  case [opponent, strategy]
  # should lose these rounds
  in ["A", "X"]
    return ["A", "Z"]
  in ["B", "X"]
    return ["B", "X"]
  in ["C", "X"]
    return ["C", "Y"]
  # should draw these rounds
  in ["A", "Y"]
    return ["A", "X"]
  in ["B", "Y"]
    return ["B", "Y"]
  in ["C", "Y"]
    return ["C", "Z"]
  # should win these rounds
  in ["A", "Z"]
    return ["A", "Y"]
  in ["B", "Z"]
    return ["B", "Z"]
  in ["C", "Z"]
    return ["C", "X"]
  end
end

def determine_round(opponent, player)
  case [opponent, player]
  in ["C", "X"]
    return 6 + score_for(player)
  in ["A", "Y"]
    return 6 + score_for(player)
  in ["B", "Z"]
    return 6 + score_for(player)
  in ["A", "X"]
    return 3 + score_for(player)
  in ["B", "Y"]
    return 3 + score_for(player)
  in ["C", "Z"]
    return 3 + score_for(player)
  else
    return score_for(player)
  end
end

def score_for(player)
  player.ord - ("X".ord - 1)
end

main
