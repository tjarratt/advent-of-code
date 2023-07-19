defmodule Mix.Tasks.Aoc do
  use Mix.Task

  def run(["1"]) do
    IO.puts Day01.part_one
    IO.puts Day01.part_two
  end

  @shortdoc "Calculate solution(s) for Day 1"
  @moduledoc """
  A custom mix task that runs the code to calculate solutions for Advent of Code 2022
  """
  def run(_) do
    IO.puts("That's the bees' knees")
  end
end
