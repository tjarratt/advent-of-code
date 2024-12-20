defmodule Day01 do
  use AocTemplate

  def part_one() do
    "input"
    |> read_file!()
    |> split_lines()
    |> parse()
    |> sort()
    |> compute_distance()
    |> Enum.sum()
  end

  def part_two() do
    "input"
    |> read_file!()
    |> split_lines()
    |> parse()
    |> compute_similarity()
    |> Enum.sum()
  end

  defp parse(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split(~r[\s+])
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  defp sort({first, second}) do
    {
      Enum.sort(first),
      Enum.sort(second)
    }
  end

  defp compute_distance({first, second}) do
    Enum.zip(first, second)
    |> Enum.map(fn {first, second} -> abs(first - second) end)
  end

  defp compute_similarity({first, second}) do
    frequencies = Enum.frequencies(second)

    Enum.map(first, fn id -> id * Map.get(frequencies, id, 0) end)
  end
end
