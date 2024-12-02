defmodule Day02 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> Enum.map(fn line -> line |> String.split(" ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.reject(&unsafe?/1)
    |> Enum.count()
  end

  def unsafe?([head, tail]) do
    abs(tail - head) not in [1, 2, 3]
  end

  def unsafe?([head, neck | tail] = reports) do
    cond do
      reports != Enum.sort(reports, :asc) and reports != Enum.sort(reports, :desc) -> true
      unsafe?([head, neck]) -> true
      true -> unsafe?([neck | tail])
    end
  end

  def unsafe?(_), do: false
end
