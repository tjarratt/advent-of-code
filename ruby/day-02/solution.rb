#!/usr/bin/env ruby

def main
  score = File.read("input")
              .split("\n")
              .map { |line| determine_round(*line.split(' ')) }
              .inject(:+)
  
  puts "solution for part 1 is #{score}"
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
