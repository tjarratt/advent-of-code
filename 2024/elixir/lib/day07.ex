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

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(&parse_equation/1)
    |> Enum.filter(&solveable?(&1, :part_two))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp solveable?({test_value, numbers}) do
    numbers
    |> solutions()
    |> Enum.any?(fn equation -> compute(equation) == test_value end)
  end

  defp solveable?({test_value, numbers}, :part_two) do
    numbers
    |> solutions_part_two()
    |> Enum.any?(fn equation -> compute(equation) == test_value end)
  end

  defp compute([x, :+, y | rest]) do
    compute([x + y | rest])
  end

  defp compute([x, :*, y | rest]) do
    compute([x * y | rest])
  end

  defp compute([x, :||, y | rest]) do
    result = "#{x}#{y}" |> String.to_integer()

    compute([result | rest])
  end

  defp compute([value]), do: value

  defp solutions([x, y]),
    do: [
      [x, :+, y],
      [x, :*, y]
    ]

  defp solutions([x | rest]) do
    solutions = solutions(rest)

    Enum.map(solutions, fn soln -> [x, :+ | soln] end) ++
      Enum.map(solutions, fn soln -> [x, :* | soln] end)
  end

  defp solutions_part_two([x, y]),
    do: [
      [x, :+, y],
      [x, :*, y],
      [x, :||, y]
    ]

  defp solutions_part_two([x | rest]) do
    solutions = solutions_part_two(rest)

    Enum.map(solutions, fn soln -> [x, :+ | soln] end) ++
      Enum.map(solutions, fn soln -> [x, :* | soln] end) ++
      Enum.map(solutions, fn soln -> [x, :|| | soln] end)
  end

  defp parse_equation(line) do
    [head, rest] = String.split(line, ": ")

    test_value = String.to_integer(head)
    numbers = String.split(rest, " ", trim: true) |> Enum.map(&String.to_integer/1)

    {test_value, numbers}
  end
end
