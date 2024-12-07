defmodule Day07 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&parse_equation/1)
    |> Enum.filter(&solveable?/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp solveable?({test_value, numbers}) do
    numbers
    |> solutions()
    |> Enum.any?(fn equation -> compute(equation) == test_value end)
  end

  def compute([x, :+, y | rest]) do
    compute([x + y | rest])
  end

  def compute([x, :*, y | rest]) do
    compute([x * y | rest])
  end

  def compute([value]), do: value

  def solutions([x, y]),
    do: [
      [x, :+, y],
      [x, :*, y]
    ]

  def solutions([x | rest]) do
    solutions = solutions(rest)

    Enum.map(solutions, fn soln -> [x, :+ | soln] end) ++
      Enum.map(solutions, fn soln -> [x, :* | soln] end)
  end

  defp parse_equation(line) do
    [head, rest] = String.split(line, ": ")

    test_value = String.to_integer(head)
    numbers = String.split(rest, " ", trim: true) |> Enum.map(&String.to_integer/1)

    {test_value, numbers}
  end
end
