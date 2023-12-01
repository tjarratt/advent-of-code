defmodule Mix.Tasks.Aoc do
  use Mix.Task

  def run(["1"]) do
    IO.puts(Day01.part_one())
  end

  @shortdoc "Calculate solution(s) for a given day"
  @moduledoc """
  A custom mix task that runs the code to calculate solutions for Advent of Code 2022
  """
  def run(_) do
    IO.puts("Sorry, that day hasn't been written yet")
  end
end