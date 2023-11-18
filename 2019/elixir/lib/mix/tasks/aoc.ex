defmodule Mix.Tasks.Aoc do
  use Mix.Task

  def run(["1"]) do
    IO.puts(Day01.part_one())
    IO.puts(Day01.part_two())
  end

  def run(["2"]) do
    IO.puts(Day02.part_one())
    IO.puts(Day02.part_two())
  end

  def run(["3"]) do
    IO.puts(Day03.part_one())
    IO.puts(Day03.part_two())
  end

  def run(["4"]) do
    IO.puts(Day04.part_one())
    IO.puts(Day04.part_two())
  end

  @shortdoc "Calculate solution(s) for Day 1"
  @moduledoc """
  A custom mix task that runs the code to calculate solutions for Advent of Code 2022
  """
  def run(_) do
    IO.puts("Sorry, that day hasn't been written yet")
  end
end
