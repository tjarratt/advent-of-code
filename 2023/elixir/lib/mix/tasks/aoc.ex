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

  def run(["5"]) do
    IO.puts(Day05.part_one())
    IO.puts(Day05.part_two())
  end

  def run(["6"]) do
    IO.puts(Day06.part_one())
    IO.puts(Day06.part_two())
  end

  def run(["7"]) do
    IO.puts(Day07.part_one())
    IO.puts(Day07.part_two())
  end

  def run(["8"]) do
    IO.puts(Day08.part_one())
    IO.puts(Day08.part_two())
  end

  def run(["9"]) do
    IO.puts(Day09.part_one())
    IO.puts(Day09.part_two())
  end

  def run(["10"]) do
    IO.puts(Day10.part_one())
    IO.puts(Day10.part_two())
  end

  @shortdoc "Calculate solution(s) for a given day"
  @moduledoc """
  A custom mix task that runs the code to calculate solutions for Advent of Code 2022
  """
  def run(_) do
    IO.puts("Sorry, that day hasn't been written yet")
  end
end
